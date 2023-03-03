# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: yizhang <zhaozicen951230@gmail.com>          +#+                      #
#                                                    +#+                       #
#    Created: 2023/03/03 15:44:45 by yizhang       #+#    #+#                  #
#    Updated: 2023/03/03 15:49:38 by yizhang       ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME = pipex
FLAG = gcc -Wall -Werror -Wextra
SRC = main.c

all: ${NAME}

${NAME}: ${SRC}
		${FLAG} ${SRC} -o ${NAME}

clean:

fclean:clean
	rm -rf ${NAME}

re:fclean all