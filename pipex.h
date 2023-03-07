/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   pipex.h                                            :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <zhaozicen951230@gmail.com>          +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/03 15:34:15 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/07 13:31:59 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_H
#define PIPEX_H

#include <unistd.h> //dup2,pipe,execve
#include <fcntl.h>//open,close
#include <stdio.h>//fork
#include <sys/wait.h>
#include "ft_printf/ft_printf.h"

void	run(char *argv, char **envp);
char	*find_path(char **cmd, char **envp);
void	print_error(void);

#endif