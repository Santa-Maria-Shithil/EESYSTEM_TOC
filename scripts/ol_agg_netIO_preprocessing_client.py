 
i=1
j=2
maxi=0
maxj=0
x=[]
y=[]

y.append(0.0)

x.append(0)


a=[]

a.append(0.0)

b=[]

b.append(0.0)

c=[]

c.append(0.0)


d=[]

d.append(0.0)

client=[]
client.append(0.0)
client.append(1)


insum1=[]
insum2=[]
insum3=[]
insum4=[]
insum5=[]
sorted_array_in=[0,0,0,0,0]
outsum1=[]
outsum2=[]
outsum3=[]
outsum4=[]
outsum5=[]
sorted_array_out=[0,0,0,0,0]
tput_median=[]
for x in range(0,1000):
    insum1.append(0.0)
    insum2.append(0.0)
    insum3.append(0.0)
    insum4.append(0.0)
    insum5.append(0.0)
    outsum1.append(0.0)
    outsum2.append(0.0)
    outsum3.append(0.0)
    outsum4.append(0.0)
    outsum5.append(0.0)

path="E:\\open_loop\\updated_rps\\effects_of_load\\35_clients"
#path="E:\effect of durable log\without durable"
nclient=35
filename=".\\scripts\\updated_rps\\"
client_cpu_usage_limit=3000


j=-1

for i in range(1,6):
    myfile = open(path+"\\run"+str(i)+"\\logs1\\logs1\\netIO_client.txt")
    j=0
    for line in myfile:
        try:
            
            line1=line.split(":")
            line2=line1[1].split("/")
            line3=line2[0][-3:]
            line4=line2[1][-3:]
            l1=line2[0].split(line3)
            l2=line2[1].split(line4)
        
            latency=line.split(":")
            line3=line3.strip()
            line4=line4.strip()

            if line3.lower() == "KB".lower():
                indata=(float(l1[0])*1024)
            if line3.lower() == "MB".lower():
        
                indata=(float(l1[0])*1024*1024)
            if line3.lower() == "GB".lower():
                indata=(float(l1[0])*1024*1024*1024)

            if line4.lower() == "KB".lower():
                outdata=(float(l2[0].strip())*1024)
            if line4.lower() == "MB".lower():
    
                outdata=(float(l2[0].strip())*1024*1024)
            if line4.lower() == "GB".lower():
                outdata=(float(l[0].strip())*1024*1024*1024)
                
            if i==1:
                #print(l[0])
                insum1[j]=insum1[j]+float(indata)
                outsum1[j]=outsum1[j]+float(outdata)
            if i==2:
                insum2[j]=insum2[j]+float(indata)
                outsum2[j]=outsum2[j]+float(outdata)
            if i==3:
                insum3[j]=insum3[j]+float(indata)
                outsum3[j]=outsum3[j]+float(outdata)
            if i==4:
                insum4[j]=insum4[j]+float(indata)
                outsum4[j]=outsum4[j]+float(outdata)
            if i==5:
                insum5[j]=insum5[j]+float(indata)
                outsum5[j]=outsum5[j]+float(outdata)
            j=j+1

        except Exception as e:
            print("Oops!", e.__class__, "occurred.")
            print("Next entry.")
            print()
        if j==700:
            break
    # plotting the points 
    myfile.close()
  
#print(outsum1)
myfile = open(filename,"w")
in_dif=0
out_dif=0

for x in range(0,700):
    sorted_array_in[0]=insum1[x]
    sorted_array_in[1]=insum2[x]
    sorted_array_in[2]=insum3[x]
    sorted_array_in[3]=insum4[x]
    sorted_array_in[4]=insum5[x]
    
    sorted_array_in.sort()

    sorted_array_out[0]=outsum1[x]
    sorted_array_out[1]=outsum2[x]
    sorted_array_out[2]=outsum3[x]
    sorted_array_out[3]=outsum4[x]
    sorted_array_out[4]=outsum5[x]
    
    sorted_array_out.sort()
    
    print(sorted_array_in)
    #myfile.write(str((sum1[x]+sum2[x]+sum3[x]+sum4[x]+sum5[x])/3)+"\n")
    #myfile.write(str((sum1[x]+sum2[x]+sum3[x])/3)+"\n")
    
    myfile.write(str((sorted_array_in[3]-in_dif)/2)+":"+str((sorted_array_out[3]-out_dif)/2)+"\n")
    in_dif=sorted_array_in[3]
    out_dif=sorted_array_out[3]
                     
myfile.close()