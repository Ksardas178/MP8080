Описание:
=========

Что это?
--------

Данная программа представляет собой транслятор из машинных команд в
бинарные (опционально – восьмеричные) коды для ручного ввода в
лабораторный стенд с однокристальным 8-разрядным МП КР580ВМ80А.

Как этим пользоваться?
----------------------

### Что для этого нужно?

Для успешного запуска необходимы:

-   Компьютер с ОС Linux;

-   Программа yacc (тестировалось на GNU Bison);

-   Программа lex (тестировалось на Flex).

Перечисленные программы, скорее всего, обсуждались в пятом семестре в
курсе транслирующих систем и не должны вызывать затруднений. Для
установки можно воспользоваться следующими консольными командами:

    sudo apt-get update
    sudo apt-get install flex
    sudo apt-get install bison

    which flex /\*Sanity check to make sure flex is installed\*/
    which bison /\*Sanity check to make sure bison is installed\*/

### Как это запустить?

Итак, у Вас установлены все программы, а проект скачан с репозитория.
Далее в терминале переходим в корневую папку проекта и вводим:

    ./build

Запуск собранного транслятора осуществляется командой:

    ./generated/run

В качестве аргументов можно (и рекомендуется) указывать текстовые файлы
с программой.

Также при вызове транслятора можно использовать следующие ключи:

    --opnames
    --octal
  
Первый добавляет короткую подсказку по оттранслированным командам, второй –
изменяет формат вывода на восьмеричное представление.

Что писать во входном файле?
----------------------------

Как ранее говорилось, входной файл представляет собой набор
ассемблеро-подобных команд, следующих друг за другом на новой строке
либо отделенных пробелами. Например:

![image](https://user-images.githubusercontent.com/43096732/118685722-fc2eab00-b80b-11eb-973a-69c2e30c03ed.png)

Также здесь нужно отметить, что транслятор поддерживает комментарии в
стиле Си:

-   /\*comment\*/

-   //comment

### А что-то еще туда можно записывать?

Конечно, можно.

Первое, и самое важное: поддерживаются префиксы для систем счисления.
Система счисления по умолчанию – десятичная. Учитывайте это при
написании программ. Остальные поддерживаемые префиксы:

-   b – binary, двоичная;

-   o – octal, восьмеричная;

-   h – hexadecimal, 16-ричная;

-   d – decimal, десятичная (префикс не обязателен, используется
    по умолчанию).

Также поддерживаются все арифметические операции из языка Си (вплоть до
сдвигов, деления по модулю, инкремента и всего остального).

Пример входного файла к этим пунктам:

![image](https://user-images.githubusercontent.com/43096732/118685749-02bd2280-b80c-11eb-8212-f2da15b7dfda.png)

Внимание: при вводе аргумента, большего 11 111 111(binary) = 255(decimal),
возможны (и скорее всего возникнут) ошибки трансляции.

Арифметические операции удобны при потетрадном формировании 2-10 числа, как то:

![image](https://user-images.githubusercontent.com/43096732/118685775-09e43080-b80c-11eb-958d-6487e3410dc5.png)

### А что-то еще из полезного?

Да, в качестве экспериментальной фичи были частично добавлены метки.
Почему частично? Потому что в рамках однопроходного транслятора было
сложно реализовать предописание метки (ссылку на нее) до ее фактического
появления в программе.

Итого: можно описать метку, ПОСЛЕ чего в коде ссылаться на нее. То есть
переходы по меткам возможны только «вверх». Пример:

![image](https://user-images.githubusercontent.com/43096732/118685801-123c6b80-b80c-11eb-98f5-0eacd30c578f.png)

Фактически метка «запоминает» адрес следующей за ней команды, и при
использовании происходит подстановка этого значения вместо имени метки.

Если Вы хотите ссылаться на метку, описанную далее по тексту программы,
это можно сделать в полуавтоматическом режиме: Вы описываете метку
(ключевой символ – «&gt;») и заносите любое значение в поле адреса
команды перехода, после чего выполняете трансляцию программы. В
консольном выводе Вы увидите адреса обнаруженных транслятором меток,
после чего их можно подставить вручную в поле адреса перехода.

Помимо прочего транслятор также выполняет минимальный анализ входных
данных и выдает диагностические сообщения, что облегчает поиск ошибок в
разработанной программе.

## Еще что-то, что я должен знать?

Адреса при трансляции выставляются последовательно, начиная с нулевого. Явно задать адрес, с которого будет записана команда/блок команд невозможно. Впрочем, все в Ваших руках. Исходный код открыт для редактирования.
