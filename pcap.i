
/*
 * $Id: pcap.i,v 1.14 2004/06/10 18:24:42 wiml Exp $
 * Python libpcap
 * Copyright (C) 2001,2002, David Margrave
 * Based PY-libpcap (C) 1998, Aaron L. Rhodes

 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the BSD Licence
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
 */

%module pcap

#define DOC(NAME, VALUE)\
%{\
static char _doc_##NAME[] = VALUE;\
%}

%include doc.i

#define __doc__ pcap_doc


%{
#include <pcap.h>
#include "pypcap.h"

#include "constants.c"
%}


%init %{
  /* m is the current module */
  /* d is the dictionary for the current module */
  init_errors(m);

  /* the DLT dictionary holds any DLT_* constants available on this platform */
  {
    PyObject *dlt = PyDict_New();
    SWIG_Python_InstallConstants(dlt, pcapmodule_DLT);
    PyDict_SetItemString(d, "DLT", dlt);
    Py_DECREF(dlt);
  }

  PyModule_AddStringConstant(m, "version", pcap_lib_version());
%}

%pythoncode %{
for dltname, dltvalue in _pcap.DLT.items():
  globals()[dltname] = dltvalue

%}

/* typemaps */

/* let functions return raw python objects */
%typemap(python, out) PyObject * {
  $result = $1;
}

/* let functions take raw python objects */
%typemap(python, in) PyObject * {
  $1 = $input;
}

/* functions taking IPv4 addresses as unsigned 32-bit integers */
%typemap(python, in) in_addr_t {
  if (PyInt_CheckExact($input)) {
    $1 = (unsigned long)PyInt_AS_LONG($input);
  } else if (!PyNumber_Check($input)) {
    PyErr_SetString(PyExc_TypeError, "argument must be an integer");
    SWIG_fail;
  } else {
    PyObject *longobject = PyNumber_Long($input);
    if (longobject == NULL) { SWIG_fail; }
    $1 = PyLong_AsUnsignedLong(longobject);
    Py_DECREF(longobject);
    if (PyErr_Occurred()) { SWIG_fail; } /* In case AsUnsignedLong() failed */
  }
}

%exception {
  $function
  if(PyErr_Occurred()) {
    SWIG_fail;
  }
}

typedef struct {
  %extend {
    pcapObject(void);
    DOC(new_pcapObject,"create a pcapObject instance")
    ~pcapObject(void);
    DOC(delete_pcapObject,"destroy a pcapObject instance")
    void open_live(char *device, int snaplen, int promisc, int to_ms);
    DOC(pcapObject_open_live,pcapObject_open_live_doc)
    void open_dead(int linktype, int snaplen);
    DOC(pcapObject_open_dead,pcapObject_open_dead_doc)
    void open_offline(char *filename);
    DOC(pcapObject_open_offline,pcapObject_open_offline_doc)
    void dump_open(char *fname);
    DOC(pcapObject_dump_open,pcapObject_dump_open_doc)
    void setnonblock(int nonblock);
    DOC(pcapObject_setnonblock,pcapObject_setnonblock_doc)
    int getnonblock(void);
    DOC(pcapObject_getnonblock,pcapObject_getnonblock_doc)
    void setfilter(char *str, int optimize, in_addr_t netmask);
    DOC(pcapObject_setfilter,pcapObject_setfilter_doc)
    void loop(int cnt, PyObject *PyObj);
    DOC(pcapObject_loop,pcapObject_loop_doc)
    int dispatch(int cnt, PyObject *PyObj);
    DOC(pcapObject_dispatch,pcapObject_dispatch_doc)
    PyObject *next(void);
    DOC(pcapObject_next,pcapObject_next_doc)
    int datalink(void);
    DOC(pcapObject_datalink,pcapObject_datalink_doc)
    PyObject *datalinks(void);
    DOC(pcapObject_datalinks,pcapObject_datalinks_doc)
    int snapshot(void);
    DOC(pcapObject_snapshot,pcapObject_snapshot_doc)
    int is_swapped(void);
    DOC(pcapObject_is_swapped,pcapObject_is_swapped_doc)
    int major_version(void);
    DOC(pcapObject_major_version,pcapObject_major_version_doc)
    int minor_version(void);
    DOC(pcapObject_minor_version,pcapObject_minor_version_doc)
    PyObject *stats(void);
    DOC(pcapObject_stats,pcapObject_stats_doc)
    int fileno(void);
    DOC(pcapObject_fileno,pcapObject_fileno_doc)
  }
} pcapObject;


/* functions not associated with a pcapObject instance */
char *lookupdev(void);
DOC(lookupdev,lookupdev_doc)
PyObject *findalldevs(int unpack=1);
DOC(findalldevs,findalldevs_doc)
PyObject *lookupnet(char *device);
DOC(lookupnet,lookupnet_doc)

/* useful non-pcap functions */
PyObject *aton(char *cp);
DOC(aton,"aton(addr)\n\nconvert dotted decimal IP string to network byte order int")
char *ntoa(in_addr_t addr);
DOC(ntoa,"ntoa(addr)\n\nconvert network byte order int to dotted decimal IP string")

