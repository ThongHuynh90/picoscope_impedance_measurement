function signal = m_waveform(sample_freq, signal_freq, num_cycles, shape,varargin)
%% signal = m_waveform(sample_freq, signal_freq, num_cycles, shape)
% shape:
% 0 : sine no windows
% 1 : sine gauss
% 2 : sine hann
% 3 : square
% 4 : Tukey : signal = m_waveform(sample_freq, signal_freq, num_cycles, shape, percentage)
% 5 : gauss padding center
% 6 : Ramp up sine
if (shape==4)
    TuckeyPercent=0.2;
    if (nargin==5)
        TuckeyPercent=varargin{1};
    end
elseif (shape==5)
    cyclePad=2;
     if (nargin==5)
        cyclePad=varargin{1};
    end    
end

% toneBurst(500e6,2e6,5,...
%                    'Envelope','Gaussian',...
%                    'SignalLength',1500,...
%                    'Plot'   ,1,...
%                    'SignalOffset',0);
switch shape
    case 0
        signal = toneBurst(sample_freq, signal_freq, num_cycles, 'Envelope','Rectangular')';
    case 1
        signal = toneBurst(sample_freq, signal_freq, num_cycles, 'Envelope','Gaussian')';
    case 2
        signal = toneBurst(sample_freq, signal_freq, num_cycles, 'Envelope','Hanning')';
    case 3
        code=repmat(1.5,1,num_cycles/0.5);
        code=code.*(mod((1:num_cycles/0.5),2)*2-1);
        signal=ge_squarewave_genterate(code,sample_freq,signal_freq);
        signal=[0;signal; 0];
    case 4
        signal = toneBurst(sample_freq, signal_freq, num_cycles, 'Envelope','Rectangular')';
        signal=signal.*tukeywin(length(signal),TuckeyPercent);
    case 5
        signal = toneBurst(sample_freq, signal_freq, num_cycles, 'Envelope','Gaussian')';
%         mid=find(
        signal1 = toneBurst(sample_freq, signal_freq, cyclePad, 'Envelope','Rectangular')';
    signal=[signal(1:round(end/2)); -signal1; signal(round(end/2)+1:end)]; 
    case 6
         signal = toneBurst(sample_freq, signal_freq, num_cycles, 'Envelope','Rectangular')';
         window=(1:length(signal))';
         window(end)=0;
         signal=signal.*window/length(signal);
         
    otherwise
        error('Unknown optional input.');
end

end