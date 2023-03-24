/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   main.c                                             :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <zhaozicen951230@gmail.com>          +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/03 15:37:21 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/24 15:54:38 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

/* static void	leaks(void)
{
	system("leaks -q pipex");
} */

int	main(int argc, char **argv, char **envp)
{
	if (argc != 5)
		print_error("Error: bad arguments\n", 42);
	m_pipex(argv, envp);
	return (0);
}
