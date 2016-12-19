function file_con=readfold(myfold)

i=1;
file_con=cell(length(myfold)-5,1);
% newfid = fopen('processedEmail.txt','w');
for ind=4:3944
    
fid = fopen(myfold(ind).name);

if fid
    email_contents = fscanf(fid, '%c', inf);
%     fclose(fid);
else
    email_contents = '';
    fprintf('Unable to open %s\n', filename);
end   

% ========================== Preprocess Email ===========================

% Find the Headers ( \n\n and remove )
% Uncomment the following lines if you are working with raw emails with the
% full headers

hdrstart = strfind(email_contents, ([char(10) char(10)]));
email_contents = email_contents(hdrstart(1):end);

% Lower case
email_contents = lower(email_contents);

% Strip all HTML
% Looks for any expression that starts with < and ends with > and replace
% and does not have any < or > in the tag it with a space
email_contents = regexprep(email_contents, '<[^<>]+>', ' ');

% Handle Numbers
% Look for one or more characters between 0-9
email_contents = regexprep(email_contents, '[0-9]+', 'number');

% Handle URLS
% Look for strings starting with http:// or https://
email_contents = regexprep(email_contents, ...
                           '(http|https)://[^\s]*', 'httpaddr');

% Handle Email Addresses
% Look for strings with @ in the middle
email_contents = regexprep(email_contents, '[^\s]+@[^\s]+', 'emailaddr');

% Handle $ sign
email_contents = regexprep(email_contents, '[$]+', 'dollar');


% ========================== Tokenize Email ===========================

% % Output the email to screen as well
% fprintf('\n==== Processed Email ====\n\n');
% 
% % Process file
% l = 0;
processed_email=[];
while ~isempty(email_contents)

    % Tokenize and also get rid of any punctuation
    [str, email_contents] = ...
       strtok(email_contents, ...
              [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);
   
    % Remove any non alphanumeric characters
    str = regexprep(str, '[^a-zA-Z0-9]', '');

    % Stem the word 
    % (the porterStemmer sometimes has issues, so we use a try catch block)
    try str = porterStemmer(strtrim(str)); 
    catch str = ''; continue;
    end;

    % Skip the word if it is too short
    if length(str) < 1
       continue;
    end
    processed_email=strcat(processed_email,{' '},str);
    processed_email=processed_email{1};

end
file_con{i}= processed_email;
fclose(fid);
newid=fopen(myfold(ind).name,'w');
fprintf(newid,'%s\n',file_con{i});
fclose(newid);
i=i+1;
end
% fclose(newfid);

end