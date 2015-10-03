% Querying the VA file
clear;
disp('Select the query file');
[file,path] = uigetfile('*.csv','Select the query file');
disp(strcat('you have selected:',20,file));
fullpath = strcat(path,file);
p1task1Function(10,10,10,fullpath);

load('VA.mat','b');
word_file = csvread('wordfiles/epidemic_word_file_query.csv'); 
VperFile = 0;
file_index = 1;
for i = 1:length(word_file)
                
    if file_index == word_file(i)
        VperFile = VperFile + 1;
    else break;
    end

end

VperState = 0;     

for i = 1:VperFile
    if word_file(i,2) == 1
        VperState = VperState + 1;
    else
        break
    end
end

num_states = word_file(VperFile,2);
file_count = length(word_file)/VperFile;

s = size(word_file);
data = word_file(:,4:end);
vector_approximations = [];

for f = 1:file_count
    file_approximation = [];
    for i = 1:num_states

        word_sum = 0;
        for j = ((f-1)*VperFile+(i-1)*VperState+1):((f-1)*VperFile+i*VperState)
            for k = 1:(s(2)-3)

            word_sum = word_sum + data(j,k); 

            end  
            
        end
        word_sum = word_sum/(VperState*(s(2)-3));
        file_approximation = [file_approximation;word_sum];

    end
    
    vector_approximations = [vector_approximations,file_approximation];
    
    
end

d = num_states;

B = zeros(d,1);

for j = 1:d
    if j<=mod(b,d)
        B(j) = floor(b/d)+1;
    else
        B(j) = floor(b/d);
    end
end

partition_points = {};

for i = 1:d
    partition_points{i} = linspace(0,1,2^B(i)+1);
end

VAq_data = [];
save('filecount.mat','file_count');
for i = 1:file_count
    VA_file = [];
    for j = 1:d
        
        for k = 1:length(partition_points{j})
            if vector_approximations(j,i)<=partition_points{j}(k)
                VA_file = [VA_file,k-2];
                break;
                       
            end
        end
    
    end
    VAq_data = [VAq_data;VA_file];

end

VAq = {};
for i = 1:file_count
    VA1 = [];
    for j = 1:d
        VA1 = [VA1,dec2bin(VAq_data(i,j))];
    end
    %VAq{i} = dec2bin(str2num(VA1)); 
    VAq{i} = VA1;
end
save('VAq.mat','VAq','fullpath','VAq_data');
clear;
load('VA.mat');
load('VAq.mat');

t = input('enter the value of t: ');
%--------------------------------------------------------------------------
load('files.mat');
current_cell = VAq{1};
potential_files = [];
access_count = 0;
for i =1:length(VA)
    if length(VAq{1})==length(VA{i})
        if min(VAq{1}==VA{i})
            current_vector = VA{i};
            current_vector = whos('current_vector');
            access_count = access_count + current_vector.bytes;
            potential_files = [potential_files,i];
        end
    end
end
filenamemapping = struct2cell(files);
sim_measure = [];
    for i = 1:length(potential_files)
        %sim_measure(i) = sim_euc(fullpath,strcat('input/',num2str(potential_files(i)),'.csv'));
        temp_file = strcat('input/',filenamemapping(1,potential_files(i)));
        sim_measure(i) = sim_euc(fullpath,temp_file{1});
    end
    sim_measures = [potential_files',sim_measure'];
if length(potential_files)>=t

    [sortedValues,sortIndex] = sort(sim_measure(:),'descend');
    maxIndex = sortIndex(1:t);
    
    disp('top t similar simulations are:');
    for i = 1:length(maxIndex)
        disp(filenamemapping(1,sim_measures(maxIndex(i))));
    end
    disp(strcat('Number of bytes accessed from index:',20,num2str(access_count),' Bytes'));
    disp(strcat('Number of compressed vectors expanded:',20,num2str(length(potential_files))));

else
    
    files_left = t-length(potential_files);
    
    for i = 1:length(VA)
        
        dist(i) = sum(abs(VAq_data(1,:)-VA_data(i,:)));
        
    end
        
    [values,indices] = sort(dist,'ascend');
    potential_files_all = unique([potential_files,indices(1:files_left)]);
    while(length(potential_files_all)<t)
        
        potential_files_all = [potential_files_all,indices(files_left+1)];
        files_left = files_left+1;
        
    end
    sim_measure = [];
    access_count = 0;
    for i = 1:length(potential_files_all)
        current_vector = VA{potential_files_all(i)};
        current_vector = whos('current_vector');
        access_count = access_count + current_vector.bytes;
        sim_measure(i) = sim_euc(fullpath,strcat('input/',num2str(potential_files_all(i)),'.csv'));
    end
    
    sim_measures = [potential_files_all',sim_measure'];
    [sortedValues,sortIndex] = sort(sim_measure(:),'descend');
    maxIndex = sortIndex(1:t);
    filenamemapping = struct2cell(files);
    disp('top t similar simulations are:');
    for i = 1:length(maxIndex)
        disp(filenamemapping(1,sim_measures(maxIndex(i))));
    end
    disp(strcat('Number of bytes accessed from index:',20,num2str(access_count),' Bytes'));
    disp(strcat('Number of compressed vectors expanded:',20,num2str(length(potential_files_all)+length(potential_files))));

end
    
