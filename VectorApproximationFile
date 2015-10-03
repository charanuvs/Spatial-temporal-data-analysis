%Creating Vector Approximation file

%p1task1;
b = input('Enter the value of b: ');
word_file = csvread('wordfiles/epidemic_word_file.csv'); 
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

%B = zeros(d,1);

for j = 1:d
    if j<=mod(b,d)
        B(j) = floor(b/d)+1;
    else
        B(j) = floor(b/d);
    end
end

partition_points = {};

for i = 1:d
    %partition_points{i} = linspace(0,1,B(i)+2);
    partition_points{i} = linspace(0,1,2^B(i)+1);
end

VA_data = [];
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
    VA_data = [VA_data;VA_file];

end

VA = {};
for i = 1:file_count
    VA1 = [];
    for j = 1:d
        VA1 = [VA1,dec2bin(VA_data(i,j))];
    end
    %VA{i} = dec2bin(str2num(VA1)); 
    VA{i} = VA1;
end

for i = 1:length(VA)

    VA_length(i) = length(VA{i});

end
    


num_bytes = whos('VA');
% for i = 1:length(VA)
%     
%     disp(VA{i});
%     
% end
save VA;
disp(strcat('Size of the index structure is ',20,num2str(num_bytes.bytes),' Bytes'));

