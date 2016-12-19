import glob
import mincemeat
import operator
text_files=glob.glob('word/*')

def file_contents(file_name):
    f=open(file_name)
    try:
        return f.read()
    finally:
        f.close()

source=dict((file_name,file_contents(file_name))
            for file_name in text_files)

def mapfn(key, value):
#print type(content)
#result_file=open('test.txt','w')  
    for w in value.split(' '):
        if w!=' ':
    #result_file.write(word+'\n')
            yield w,1


def reducefn(key, value):  
    result=sum(value)
    return result

# start the server  
  
s = mincemeat.Server()  
s.datasource = source  
s.mapfn = mapfn  
s.reducefn = reducefn  
  
results = s.run_server(password="526918")  
result_file=open('wordList.txt','w')
#save results
for result in results:
    if results[result]>30:
    	result_file.write(result+'\n')
        #print result+' '+str(results[result])+'\n'
