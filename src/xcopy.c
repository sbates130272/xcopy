/*
 * Eideticom xcopy test code.
 * Copyright (c) 2019, Eideticom
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 */

#define _GNU_SOURCE

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

//#define SYS_splice 275 // For x86 only!!
#define SPLICE_F_P2PDMA 0x10

int main(int argc, char **argv)
{
	int fread, fwrite, ret;

	fread = open(argv[1], O_DIRECT | O_RDONLY);
	if (fread == -1) {
		perror("open() on fread:");
		exit(-1);
	}
	fwrite = open(argv[2], O_DIRECT | O_CREAT | O_WRONLY,
		      S_IRUSR | S_IWUSR);
	if (fwrite == -1) {
		perror("open() on fwrite:");
		exit(-1);
	}
	
	ret = syscall(SYS_splice, fread, NULL, fwrite, NULL, 4096, SPLICE_F_P2PDMA);
	if (ret == -1) {
		perror("syscall():");
		exit(-1);
	}

	return 0;
}
