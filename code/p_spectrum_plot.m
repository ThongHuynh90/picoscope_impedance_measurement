
function [aa,bb]=p_spectrum_plot( signal,fs)
%[t signal f H N] = m_spectrum_plot( signal,fs,typeMag,varargin)
%   Detailed explanation goes here






[f H N] = pspectrum_plot( signal,fs);
X_mags=abs(H)./(N/2);
Xmax=max(X_mags(int32(1):N));
%    Xmax=1;
  X_mags=X_mags/Xmax;

    X_mags=20*log10(X_mags);
    Yunit='(dB)';



subplot(2,1,2);

bb=plot(f*1e-6, X_mags);
% xlim([	(-max(f)/20)  max(f)]/10);
% xlim([-1 8]);
% ylim([-60 5]);
[maximumy,i] = max(X_mags); % i is the index of your max y values
maxfreq = f(i);

lb=strcat(' f0 = ',num2str(maxfreq));

% line([maxfreq maxfreq]*1e-6, get(gca, 'ylim'),'LineStyle',':');
% line([2*maxfreq 2*maxfreq]*1e-6, get(gca, 'ylim'),'LineStyle',':');
% line([3*maxfreq 3*maxfreq]*1e-6, get(gca, 'ylim'),'LineStyle',':');

grid on;


subplot(2,1,1);
t=(0:length(signal)-1)/fs;
aa=plot(t*1e6,signal);
% grid on;

end

function [f H N] = pspectrum_plot( signal,fs)
N=numel(signal)*10;
N_2 = ceil(N/2);
H = fft(signal,N);
f = [0 : N-1]*fs/N;

H=H(1:N_2);
f=f(1:N_2);
N=N_2;
end