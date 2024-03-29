/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   b_utils.c                                          :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/09 12:30:34 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/20 16:14:17 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

char	*get_next_line(int fd)
{
	int		i;
	int		j;
	char	buff;
	char	*str;

	i = 8;
	j = 0;
	str = malloc(6000);
	while (i)
	{
		i = read(fd, &buff, 1);
		if (i < 0)
			return (free(str), NULL);
		if (i > 0)
			str[j] = buff;
		if (i == 0 || str[j] == '\n')
			break ;
		j++;
	}
	str[j++] = '\n';
	str[j++] = '\0';
	return (str);
}
