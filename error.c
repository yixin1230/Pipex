/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   error.c                                            :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/24 15:35:07 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/27 14:04:08 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	print_error(char *str, int i)
{
	if (i == 42)
	{
		ft_putstr_fd(str, 2);
		exit(1);
	}
	if (i == 1 || i == 126 || i == -1)
		ft_putstr_fd(strerror(errno), 2);
	else if (i == 127 || i == -127)
		ft_putstr_fd("Command not found", 2);
	if (i == 1 || i == 126 || i == 127
		|| i == -127 || i == -1)
	{
		ft_putstr_fd(": ", 2);
		ft_putstr_fd(str, 2);
		ft_putstr_fd("\n", 2);
	}
	if (i > 0)
		exit(i);
}
