%% Make Video
function make_vid(F, fname)

try
    % VideoWriter based video creation
    h_avi = VideoWriter(fname, 'Uncompressed AVI');
    h_avi.FrameRate = 30;
    h_avi.open();
catch
    % Fallback deprecated avifile based video creation
    h_avi = avifile(fname,'fps',30);
end

figure(3);
% if image type is double, modify the following line accordingly if necessary
for i=1:length(F)
    imagesc(uint8(F{i}));
    axis image; axis off;drawnow;
    try
        % VideoWriter based video creation
        h_avi.writeVideo(getframe(gcf));
    catch
        % Fallback deprecated avifile based video creation
        h_avi = addframe(h_avi, getframe(gcf));
    end
end

try
    % VideoWriter based video creation
    h_avi.close();
catch
    % Fallback deprecated avifile based video creation
    h_avi = close(h_avi);
end
clear h_avi;

end