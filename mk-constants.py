# $Id: mk-constants.py,v 1.2 2004/06/07 05:34:49 wiml Exp $
#
# Python libpcap
# Copyright (C) 2004, Wim Lewis
# Based on:
#   PY-libpcap (C) 1998, Aaron L. Rhodes
#   constants.i (C) 2001,2002, David Margrave
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the BSD Licence
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

linktypes = (
'DLT_NULL',
'DLT_EN10MB',
'DLT_EN3MB',
'DLT_AX25',
'DLT_PRONET',
'DLT_CHAOS',
'DLT_ARCNET',
'DLT_ARCNET_LINUX',
'DLT_SLIP',
'DLT_SLIP_BSDOS',
'DLT_FDDI',
'DLT_HIPPI',
'DLT_ATM_RFC1483',
'DLT_RAW',
'DLT_PPP',
'DLT_PPP_BSDOS',
'DLT_PPP_SERIAL',
'DLT_PPP_ETHER',
'DLT_C_HDLC',
# 'DLT_CHDLC',   # CHDLC is a compatibility alias for C_HDLC
'DLT_HDLC',
'DLT_ATM_CLIP',
'DLT_IEEE802',
'DLT_IEEE802_11',
'DLT_IEEE802_11_RADIO',
'DLT_IEEE802_11_RADIO_AVS',
'DLT_LOOP',
'DLT_LINUX_SLL',
'DLT_LTALK',
'DLT_ECONET',
'DLT_IPFILTER',
'DLT_PFLOG',
'DLT_PFSYNC',
'DLT_CISCO_IOS',
'DLT_PRISM_HEADER',
'DLT_AIRONET_HEADER',
'DLT_ENC',
'DLT_APPLE_IP_OVER_IEEE1394',
'DLT_AURORA',
'DLT_DOCSIS',
'DLT_FRELAY',
'DLT_IP_OVER_FC',
'DLT_JUNIPER_ATM1',
'DLT_JUNIPER_ATM2',
'DLT_JUNIPER_ES',
'DLT_JUNIPER_GGSN',
'DLT_JUNIPER_MFR',
'DLT_JUNIPER_MLFR',
'DLT_JUNIPER_MLPPP',
'DLT_JUNIPER_MONITOR',
'DLT_JUNIPER_SERVICES',
'DLT_LINUX_IRDA',
'DLT_RIO',
'DLT_SUNATM',
'DLT_SYMANTEC_FIREWALL',
'DLT_TZSP'
)


import string
fp = open('constants.c', 'w')
fp.write('/* Automatically generated from\n')
rcs = '   $Id: mk-constants.py,v 1.2 2004/06/07 05:34:49 wiml Exp $\n'
fp.write(string.replace(rcs, '$', ''))
fp.write('   Do not edit this file directly, it will be overwritten \n*/\n\n')
fp.write('static struct swig_const_info const pcapmodule_DLT[] = {\n')
for dlt in linktypes:
    fp.write('#ifdef %s\n' % (dlt,))
    fp.write('{ SWIG_PY_INT, "%s", (long)(%s), 0, 0, 0 },\n' % (dlt,dlt))
    fp.write('#endif\n')
fp.write('{ 0, NULL, 0, 0, 0, 0 }\n};\n')

fp.close()



