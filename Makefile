# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: yizhang <zhaozicen951230@gmail.com>          +#+                      #
#                                                    +#+                       #
#    Created: 2023/03/03 15:44:45 by yizhang       #+#    #+#                  #
#    Updated: 2023/03/07 10:08:53 by yizhang       ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME = pipex
CC = gcc
FLAG = -Wall -Werror -Wextra
FT_PRINTF = ft_printf/libftprintf.a
SRC = 
MAIN = main.c 
OBJ = ${SRC:.c=.o}

all: ${NAME}

${NAME}: ${MAIN} ${FT_PRINTF}
		@${CC} ${FLAG} ${FT_PRINTF} ${MAIN} -o ${NAME}

${OBJ}: ${SRC}
		@${CC} ${FLAG} -c ${SRC}

${FT_PRINTF}:
	@make -C ft_printf

clean:
	@rm -rf ${OBJ}
	@make clean -C ft_printf

fclean:clean
	@rm -rf ${NAME}
	@make fclean -C ft_printf

re:fclean all
