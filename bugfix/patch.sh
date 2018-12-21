!/bin/bash

sudo cp pygooglechart.py /usr/lib/python2.7/dist-packages/pygooglechart.py
sudo rm /usr/lib/python2.7/dist-packages/pygooglechart.pyc
sudo service wfrog restart
