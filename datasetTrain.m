function X=datasetTrain(myfold,vocabList)

i=1;


X=zeros(length(myfold)-5,length(vocabList));
% newfid = fopen('processedEmail.txt','w');
for ind=4:(length(myfold)-2)
    
fid = fopen(myfold(ind).name);

if fid
    email_contents = fscanf(fid, '%c', inf);
%     fclose(fid);
else
    email_contents = '';
    fprintf('Unable to open %s\n', filename);
end

word_indices = [];
while ~isempty(email_contents)

    % Tokenize and also get rid of any punctuation
    [str, email_contents] = ...
       strtok(email_contents, ...
              [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);
   
   
    % Skip the word if it is too short
    if length(str) < 1
       continue;
    end

    % Look up the word in the dictionary and add to word_indices if
    % found
    
    
   for j=1:length(vocabList)
       if strcmp(str,vocabList{j})==1
           word_indices = [word_indices ; j];
       end
   end

end

feature=emailFeatures(word_indices);
X(i,:)=feature';
i=i+1;

end
