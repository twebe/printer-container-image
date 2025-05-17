FROM ubuntu:16.04

RUN apt-get update && apt-get -y install wget cups

RUN wget https://www.psn-web.net/cs/support/fax/common/file/Linux_PrnDriver/Driver_Install_files/mccgdi-2.0.10-x86_64.tar.gz && \
    tar -xf mccgdi-2.0.10-x86_64.tar.gz && ./mccgdi-2.0.10-x86_64/install-driver && \
    lpadmin -p panasonic-printer -E -v socket://MB2000G-1645DE -P ./mccgdi-2.0.10-x86_64/ppd/L_Panasonic-MB2000-gdi.ppd -o media=A4 && \
    cupsctl --remote-admin --remote-any --share-printers

COPY cupsd.conf /etc/cups/cupsd.conf
    
EXPOSE 631
    
CMD ["cupsd", "-f"]
