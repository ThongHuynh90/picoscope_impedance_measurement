function [ output_signal ] = p_correlation_mean( signals,varargin )
%[ output_signal ] = p_correlation_mean( signals,f0,fs )
%   signals is length X m
if isempty(signals)
    output_signal=[];
    return
end


[~,x]=size(signals);
if(nargin==3)
    output_signal = lowpass(signals(:,1),varargin{1},varargin{2});
else
    output_signal = signals(:,1);
end
sumlag=0;
lag_lim=3;
for idx=2:x
    if(nargin==3)
    signals(:,idx)=lowpass(signals(:,idx),varargin{1},varargin{2});
    end

    
    [xc,lags] = xcorr(output_signal,signals(:,idx));
    xc=xc(find(lags>=-lag_lim & lags<=lag_lim));
    lags=lags(find(lags>=-lag_lim & lags<=lag_lim));
    
    [~,I] = max(xc);
    lag=lags(I);
    sumlag=sumlag+abs(lag);
    output_signal=output_signal+circshift(signals(:,idx),lag);
end
output_signal=output_signal/x;sumlag
end

