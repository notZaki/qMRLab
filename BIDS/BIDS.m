classdef (Abstract) BIDS
    %BIDS Brain Imaging Data Structure (BIDS) data parser and handler.
    %   **Current implementaiton restriction**
    %   - BIDS folder must only contain data for a single model
    %   - All optional data for model must be included in the folder
    %   - Every data file (*.nii* and *.mat) in folder must be accompanied
    %     by a matching BIDS-formatted JSON file.
    %   - Likely other restrictions that haven't shown up during the early 
    %     testing. 
    %
    %   --Methods--
    %   loadBidsFolder(bidsFolder): Load data and fitting options from a
    %                               BIDS structured folder.
    %       *returns*: [obj,data]
    %
    %   --Properties--
    %   bidsSequenceLabel: Struct. Bids->Model conversion. Model name
    %   bidsContrastLabel: Struct. Bids->Model conversion. Names of other MRIinput's
    %   bidsConversion: Struct. Bids->Model conversion. Protocol parameter names 
    %
    
    properties (Abstract)        
        % Model-specific  Bids->Model conversion structs.
        % Must be implemented in models that inherit this class
        % They must be structs with fields that are BIDS 'strings', and
        % values which are strings matching their qMRLab model values.
        bidsSequenceLabel % Model name (first MRIinput)
        bidsContrastLabel % Names of other MRIinput's
        bidsConversion    % Protocol parameter names (see (Model).(MRIinput(1)).Prot.Format)
    end
    
    methods (Access = public)

        function [obj,data] = loadBidsFolder(obj, bidsFolder)
            %LOADBIDSFOLDER Load data from BIDS folder.
            %
            
            % Get all JSON(/BIDS) fileneames
            listJson = dir(fullfile(bidsFolder,'*.json'));
            
            % Get all data filenames
            listData = [ dir(fullfile(bidsFolder ,'*.nii*')); ...
                         dir(fullfile(bidsFolder ,'*.mat'))
                       ];
            
            % Ensure that every data file has a matching JSON file
            obj.verifyBidsFolder(listData, listJson);
            
            % Read BIDS data from files
            try
                data = obj.readBidsData(listData);
            catch ME
                ME = MException('BIDS:readBidsData', ME.message);
                throw(ME)
            end
            
            % Load fititng option parameter values into model object
            %
            obj = obj.setBidsOptions(listJson);
            
        end
    end
    
    methods (Access = private)
        
        function bidsStruct = readBids(~, fileName)
            %READBIDS Read BIDS data from JSON file and assign it to bidsStruct object
            % property.
            %
            %   Method uses external tool JSONlab for JSON parser.
            %
            
            try
                bidsStruct = loadjson(fileName);
            catch ME
                error(ME.identifier, ME.message)
            end
        end
        
        
        function obj = setBidsOptions(obj, listJson)            
            % SETBIDSOPTIONS
            %
            sequenceFields = fields(obj.bidsSequenceLabel);

            sequenceLogical = contains({listJson.name}, cell2mat(sequenceFields));
            sequenceIndices = find(sequenceLogical);
            
            bidsFields = fields(obj.bidsConversion);
            
            % Clear
            obj.Prot.(obj.bidsSequenceLabel.(cell2mat(fields(obj.bidsSequenceLabel)))).Mat = [];
            
            for ii=1:length(sequenceIndices)
                currentFileBidsStruct = readBids(obj,listJson(sequenceIndices(ii)).name);
                for jj = 1:length(bidsFields)
                    convertedField =  obj.bidsConversion.(bidsFields{jj});
                    
                    optionIndex = contains(obj.Prot.(obj.bidsSequenceLabel.(cell2mat(fields(obj.bidsSequenceLabel)))).Format, convertedField);
                    
                    fieldValue = currentFileBidsStruct.(bidsFields{jj});
                    obj.Prot.(obj.bidsSequenceLabel.(cell2mat(fields(obj.bidsSequenceLabel)))).Mat(ii, optionIndex) = fieldValue;
                end
            end
            
        end
        
        %% Private helper functions to public functions
        %
        
        function verifyBidsFolder(~, listData, listJson)
            % VERIFYBIDSFOLDER
            %
            
            for ii = 1:length(listData)
                % Remove file extension
                dotIndices = find(listData(ii).name=='.');
                dataFilePrefix = listData(ii).name(1:dotIndices(1)-1); % Get prefix up until first dot, where we assumes suffix begins.
                
                if ~any(contains({listJson.name}, [dataFilePrefix, '.json']))
                    ME = MException('BIDS:MissingJsonFile', ...
                        'Each data file (*.nii* and *.mat) in BIDS folder must have a matching *.json file. Cannot find %s', [dataFilePrefix, '.json']);
                    throw(ME)
                end
            end
        end
        
        function data = readBidsData(obj, listData)
            %READBIDSDATA
            %
            data = [];
            
            % Load ContrastLabel data
            data = obj.readContrastLabelData(listData, data);
            
            % Load SequenceLabel data
            data = obj.readSequenceLabelData(listData, data);
            
            % Data-checking
            % TO-DO IMPLEMENT
        end
        
        %% Private helper functions to other private functions
        %
        
        function data = readContrastLabelData(obj, listData, data)
            %READCONTRASTLABELDATA
            %
            contrastFields = fields(obj.bidsContrastLabel);
            for ii = 1:length(contrastFields)
                % Get indices of data files that contain the contrast in
                % the filename
                contrastIndices = contains({listData.name}, cell2mat(contrastFields(ii)));
                
                %    (Get the converted Model contrast name               )
                modelContrastName = obj.bidsContrastLabel.(cell2mat(contrastFields(ii)));
                data.(modelContrastName) = load_nii_data(listData(contrastIndices).name);
            end
        end
        
        function data = readSequenceLabelData(obj, listData, data)
            %READSEQUENCELABELDATA
            %
            sequenceFields = fields(obj.bidsSequenceLabel);
            for ii = 1:length(sequenceFields)
                
                % Get indices of data files that contain the contrast in
                % the filename
                sequenceLogical = contains({listData.name}, cell2mat(sequenceFields(ii)));
                sequenceIndices = find(sequenceLogical);
                
                modelSequenceName = obj.bidsSequenceLabel.(cell2mat(sequenceFields(ii)));
                
                for jj = 1:length(sequenceIndices)
                    tempData = load_nii_data(listData(sequenceIndices(jj)).name);
                    
                    if length(size(tempData)) == 2 % Single-slice data volumes
                        data.(modelSequenceName)(:,:,1,jj)=tempData;
                    elseif length(size(tempData)) == 3 % 3D data volumes
                        data.(modelSequenceName)(:,:,:,jj)=tempData;
                    else
                        ME = MException('BIDS:InvalidDataDimensions', ...
                            'Data must either be 2D or 3D.');
                        throw(ME)
                    end
                end
            end
        end
    end
end
