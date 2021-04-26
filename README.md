# docker-hashcat 

A fork of [dizcza/docker-hashcat](https://github.com/dizcza/docker-hashcat) compiled for Ubuntu 20.04 and CUDA 11.2.

Supports RTX 30 series cards in both CUDA and OpenCL modes.

Compatible with Vast.ai.

```
nvidia-docker run -it sergeycheperis/docker-hashcat
```

Then inside the docker container run

```
# list the available CUDA and OpenCL interfaces
hashcat -I

# run hashcat bechmark
hashcat -b
```


## Hashcat utils

Along with the hashcat, the following utility packages are installed:

* [hashcat-utils](https://github.com/hashcat/hashcat-utils) for converting raw Airodump to HCCAPX capture format; info `cap2hccapx -h`
* [hcxtools](https://github.com/zerbea/hcxtools) for inspecting, filtering, and converting capture files;
* [hcxdumptool](https://github.com/ZerBea/hcxdumptool) for capturing packets from wlan devices in any format you might think of; info `hcxdumptool -h`
* [kwprocessor](https://github.com/hashcat/kwprocessor) for creating advanced keyboard-walk password candidates; info `kwp -h`
