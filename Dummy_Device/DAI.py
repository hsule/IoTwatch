import time, random, requests
import csv
import DAN

ServerURL = 'https://1.iottalk.tw'      #with non-secure connection
#ServerURL = 'https://DomainName' #with SSL connection
Reg_addr = None #if None, Reg_addr = MAC address

sensor_list = ['hR', 'heading', 'xAcc', 'xMag', 'yAcc', 'yMag', 'zMag']

DAN.profile['dm_name'] = 'DataServer'
DAN.profile['df_list'] = sensor_list
DAN.profile['d_name'] = 'dummy' 

DAN.device_registration_with_retry(ServerURL, Reg_addr)
#DAN.deregister()  #if you want to deregister this device, uncomment this line
#exit()            #if you want to deregister this device, uncomment this line
date = time.strftime("%Y-%m-%d", time.localtime())

with open ('data/watch_hR_' + date + '.csv', 'w') as f1, open ('data/watch_heading_' + date + '.csv', 'w') as f2, \
    open ('data/watch_xAcc_' + date + '.csv', 'w') as f3, open ('data/watch_xMag_' + date + '.csv', 'w') as f4, \
    open ('data/watch_yAcc_' + date + '.csv', 'w') as f5, open ('data/watch_yMag_' + date + '.csv', 'w') as f6, \
    open ('data/watch_zMag_' + date + '.csv', 'w') as f7:

    w = []
    w.append(csv.writer(f1))
    w.append(csv.writer(f2))
    w.append(csv.writer(f3))
    w.append(csv.writer(f4))
    w.append(csv.writer(f5))
    w.append(csv.writer(f6))
    w.append(csv.writer(f7))
    
    for i in range(7):
        w[i].writerow(['datetime', 'value'])

    while True:
        for i in range(7):
            try:
                data = DAN.pull(sensor_list[i])

                if data != None:
                    w[i].writerow([time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()),data[0]])

            except Exception as e:
                print(e)
                if str(e).find('mac_addr not found:') != -1:
                    print('Reg_addr is not found. Try to re-register...')
                    DAN.device_registration_with_retry(ServerURL, Reg_addr)
                else:
                    print('Connection failed due to unknow reasons.')
                    time.sleep(1)    

        time.sleep(0.2)

