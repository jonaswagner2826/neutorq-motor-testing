%% Data Injest
clear; close all;
dataSubfolder = ['data', filesep];
vidSubfolder = [dataSubfolder, 'vids', filesep];
vidFilename = '20230817_161823_1';

idx_frame_initial = 10;

% Use r = drawrectangle to find location
roi_A = [400 45 240 115];
roi_V = [815 57 285 102];
roi_Nm = [417 710 96 58];
roi_RPM = [425 830 65 62];

v = VideoReader(strcat(vidFilename,'.mp4'));

for idx_frame = idx_frame_initial:v.NumFrames
    frame = im2gray(imrotate(v.read(idx_frame,"native"),-90));
    t(idx_frame) = v.CurrentTime;
    A(idx_frame) = processFrame(frame,roi_A); 
        if floor(A(idx_frame)) == 8; A(idx_frame) = A(idx_frame) - 8; end % correct for 0 being an 8
        if A(idx_frame) == -1; A(idx_frame) = A(idx_frame-1); end % interpolate data
        if A(idx_frame) > 1; A(idx_frame) = A(idx_frame-1); end % interpolate data (for aranious values)
    V(idx_frame) = processFrame(frame,roi_V);
        if V(idx_frame) == -1; V(idx_frame) = V(idx_frame-1); end % interpolate data
        if V(idx_frame) < 22; V(idx_frame) = V(idx_frame-1); end % interpolate data
        if V(idx_frame) > 28; V(idx_frame) = V(idx_frame-1); end % interpolate data
    Nm(idx_frame) = processFrame(frame,roi_Nm);
        if Nm(idx_frame) > 1; Nm(idx_frame) = Nm(idx_frame)*0.1; end % fix missing 0.
    RPM(idx_frame) = processFrame(frame,roi_RPM);
        if RPM(idx_frame) == -1; RPM(idx_frame) = RPM(idx_frame-1); end % interpolate data
        if RPM(idx_frame) < 10; RPM(idx_frame) = RPM(idx_frame-1); end % interpolate data (for single digit values)
        if RPM(idx_frame) >150; RPM(idx_frame) = RPM(idx_frame-1); end % interpolate for outliers...
    fprintf('Finished Frame %d\n',idx_frame)
end

T = table;
T.('Time (s)') = t';
T.('Current (A)') = hampel(A',10);
T.('Voltage (V)') = hampel(V',10);
T.('Torque (Nm)') = hampel(Nm',10);
T.('RPM') = hampel(RPM',10);
T = T(idx_frame_initial:end,:);


writetable(T,[dataSubfolder,'motorTestData_',vidFilename,'.csv'],...
    'WriteRowNames',true);


function val = processFrame(frame,roi)
    ocrResults = ocr(frame,roi,CharacterSet="0123456789.",...
        LayoutAnalysis="none");
    if ~isempty(ocrResults.Words)% && length(ocrResults.TextLines)==1
        if length(ocrResults.TextLines)==1
            val = str2double(ocrResults.TextLines{1});
        else
            val = -2;
        end
    else
        val = -1;
    end
end
% frame = imguidedfilter(im2gray(imrotate(v.read(idx_frame_initial),-90)));
% frame = im2gray(imrotate(v.read(idx_frame_initial),-90));

% Icorrected = imtophat(frame,strel("disk",15));
% frame = Icorrected;
% marker = imerode(Icorrected,strel("line",10,0));
% Iclean = imreconstruct(marker,Icorrected);
% frame = Iclean;

% frame_A = frame(roi_A(2) + (0:roi_A(4)), roi_A(1) + (0:roi_A(3)),:);
% frame_V = frame(roi_V(2) + (0:roi_V(4)), roi_V(1) + (0:roi_V(3)),:);
% frame_Nm = frame(roi_Nm(2) + (0:roi_Nm(4)), roi_Nm(1) + (0:roi_Nm(3)),:);
% frame_RPM = frame(roi_RPM(2) + (0:roi_RPM(4)), roi_RPM(1) + (0:roi_RPM(3)),:);
% 
% ocrResults = ocr(frame_V,CharacterSet="0123456789.")

% ocrResults = ocr(frame,roi).Text
% Binarize
% grayImage = frame(y(1):y(2),x(1):x(2),3);
% mask = grayImage < 99;
% imshow(mask)