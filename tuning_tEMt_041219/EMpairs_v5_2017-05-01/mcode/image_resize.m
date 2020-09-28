function image_resize(finf,iminf,sinf)
%%
if nargin == 0
    sinf.rsz = [180 360];
    sinf.fmt = 'bmp';
    sinf.sp = '/home/rouxf/MATLAB/PTBcode/EMpairs_v4_2016-1007/image_data/EMtune/';
    iminf.ext = '*';
    finf.p2d = '/home/rouxf/MATLAB/PTBcode/EMpairs_v4_2016-1007/image_data/EMtune/orig/';
    finf.fn = dir([finf.p2d,'*.',iminf.ext]);
end;
%%
if sinf.rsz(1) > sinf.rsz(2)
    sinf.rsz = fliplr(sinf.rsz);
end;
%%
for it = 1:length(finf.fn)
    try
        [A] = imread([finf.p2d,finf.fn(it).name]);
        
        sz = size(A);
        
        if sz(2) > sz(1)
            
            [B] = imresize(A,sinf.rsz);
            
        elseif sz(1) > sz(2)
            
            [B] = imresize(A, fliplr(sinf.rsz));
            
            
        end;
        
        sn = [finf.fn(it).name(1:end-4),'.',sinf.fmt];
        imwrite(B,[sinf.sp,sn],sinf.fmt);
        
        fprintf([num2str(it),'/',num2str(length(finf.fn))]);
        fprintf('\n');
    catch
    end;
end;