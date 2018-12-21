function obj = corPearson(obj,crObj)
%Explain for user here.

% Developers: * qmrstat.getBivarCorInputs (Static)
%               -- calls qmrstat.getBiVarCorVec (Private)
%               ---- calls qmrstat.cleanNan (Private)
%             * Pearson (External/robustcorrtool)

% getBivarCorInputs includes validation step. Validation step
% is not specific to the object arrays with 2 objects. N>2 can
% be also validated by qmrstat.validate (private).

% Uniformity assumptions for qmrstat_correlation objects here:
% LabelIdx
% StatLabels
% BOTH FIELDS ARE REQUIRED

if nargin<2

  crObj = obj.Object.Correlation;

elseif nargin == 2

  obj.Object.Correlation = crObj;

end

[comb, lbIdx] = qmrstat.corSanityCheck(crObj);

szcomb = size(comb);
for kk = 1:szcomb(1) % Loop over correlation matrix combinations
for zz = 1:lbIdx % Loop over labeled mask indexes (if available)

% Combine pairs
curObj = [crObj(1,comb(kk,1)),crObj(1,comb(kk,2))];

if lbIdx >1

    % If mask is labeled, masking will be done by the corresponding
    % index, if index is passed as the third parameter.
    [VecX,VecY,XLabel,YLabel,sig] = qmrstat.getBivarCorInputs(obj,curObj,curObj(1).LabelIdx(zz));

else
    % If mask is binary, then index won't be passed.
    [VecX,VecY,XLabel,YLabel,sig] = qmrstat.getBivarCorInputs(obj,curObj);

end

if strcmp(crObj(1).FigureOption,'osd')

  [r,t,pval,hboot,CI] = Pearson(VecX,VecY,XLabel,YLabel,1,sig);

elseif strcmp(crObj(1).FigureOption,'save')

  [r,t,pval,hboot,CI,h] = Pearson(VecX,VecY,XLabel,YLabel,1,sig);
  obj.Results.Correlation(zz,kk).Pearson.figure = h;
  if lbIdx>1

  obj.Results.Correlation(zz,kk).Pearson.figLabel = [XLabel '_' YLabel '_' curObj(1).StatLabels(zz)];

  else

  obj.Results.Correlation(zz,kk).Pearson.figLabel = [XLabel '_' YLabel];

  end

elseif strcmp(crObj(1).FigureOption,'disable')


  [r,t,pval,hboot,CI] = Pearson(VecX,VecY,XLabel,YLabel,0,sig);

end

% Corvis is assigned to caller (qmrstat.Pearson) workspace by
% the Pearson function.
% Other fields are filled by Pearson function.

if obj.Export2Py
  
  svds = struct();
  svds.Tag = 'Bivariate::Pearson';
  svds.Required.xData = VecX;
  svds.Required.yData = VecY;
  svds.Required.rPearson = r;
  svds.Required.xLabel = XLabel;
  svds.Required.yLabel = YLabel;
  
  svds.Optional.pval = pval;
  svds.Optional.h = hboot;
  svds.Optional.CI = CI;

  obj.Results.Correlation(zz,kk).Pearson.SVDS = svds;

end


obj.Results.Correlation(zz,kk).Pearson.r = r;
obj.Results.Correlation(zz,kk).Pearson.t = t;
obj.Results.Correlation(zz,kk).Pearson.pval =  pval;
obj.Results.Correlation(zz,kk).Pearson.hboot = hboot;
obj.Results.Correlation(zz,kk).Pearson.CI = CI;

end
end

end % Correlation

