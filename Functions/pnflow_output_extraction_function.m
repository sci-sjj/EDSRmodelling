function [pc_data, porosity, permeability, rel_perm_data, network_stats]= ...
    pnflow_output_extraction_function(outfolder)
% Christopher Zahasky
% Imperial College
% 5/1/2019

% This function extracts pc, porosity, and perm data from model output

% Extract PC data
C1 = importdata([outfolder, '_cycle1_drain.csv']);
pc_data = C1.data(:,1:2);
rel_perm_data = [C1.data(:,1), C1.data(:, 3:4)];
% Extract porosity and permeability data
% open base pnextract file, read input, and write to a new file
fid = fopen([outfolder, '_out.prt']);
Aout = textscan(fid,'%s','Delimiter','\n');
fclose(fid);

fid = fopen([outfolder, '_out.prt']);
tline = fgetl(fid);
while ischar(tline)
    %disp(tline)
    tline = fgetl(fid);
    
    if ischar(tline)
        for i = 1:14
            out = {};
            if (i == 1)
                out=regexp(tline,'Number of pores','match');
            elseif (i == 2)
                out=regexp(tline,'Number of throats','match');
            elseif (i == 3)
                out=regexp(tline,'Average connection number','match');
            elseif (i == 4)
                out=regexp(tline,'Number of connections to inlet','match');
            elseif (i == 5)
                out=regexp(tline,'Number of connections to outlet','match');
            elseif (i == 6)
                out=regexp(tline,'Number of physically isolated elements','match'); 
            elseif (i == 7)
                out=regexp(tline,'Number of triangular shaped elements','match');
            elseif (i == 8)
                out=regexp(tline,'Number of square shaped elements','match');
            elseif (i == 9)
                out=regexp(tline,'Median throat length to radius ratio','match');
            elseif (i == 10)
                out=regexp(tline,'Formation factor','match');
            end
            
            if size(out) > 0
                network_stats(i,1) = str2double(regexp(tline,'[\d.]+','match'));
            end
            
        end
        
    end
end
    fclose(fid);
    
    %network_stats = {};

% Find relevant porosity and permability data
% preallocate
tf = 0;
tk = 0;
text_row = 1;
% Search file
while tk == 0 
    % Look for row with porosity
    tf = strncmpi(Aout{1,1}(text_row,1), 'Net porosity', 12);
    if tf == 1
        aa = Aout{1,1}(text_row,1);
        porosity = str2double(aa{1}(15:end));
    end
    
    tk = strncmpi(Aout{1,1}(text_row,1), 'Absolute permeability (mD)', 26);
    if tk == 1
        aa = Aout{1,1}(text_row,1);
        permeability = str2double(aa{1}(28:end));
    end
    
    text_row = text_row+1;
end