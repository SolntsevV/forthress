( Проверка на четность )
: IsEven
	2 % not 1 = if ." Even"
		else ." Odd"
	then
;

( Проверка на простоту )
: IsPrime
	dup 0 < if ." Negative value " else
		dup 2 < if drop 0 else
			dup 4 < if drop 1 else
				dup
				dup 2 / 1 + ( for i = 2 ; i <= n / 2; i++ )
				2 do ( limit, index)
					r@ % 0
					= if 
						drop 0
						r> drop 
						r@ >r
					else dup then 
				loop
				0 = if 0 else drop 1 then
			then 
		then
	then
;

( Проверка на простоту и выделение ячейки с помощью allot )
: IsPrime-allot
	IsPrime
	cell% allot
	dup
	rot swap
	! ( запись в память )
;

( Конкатинация двух строк )
( m" 123" m" 12" concat prints )
: concat ( addr->a, addr->b -- a+b )
	dup count
	( len b, addr b, addr a )
	rot
	( addr b, len b, addr a )
	dup count
	( len a, addr a, len b, addr b )
	rot
	( len b, len a, addr a, addr b )
	swap
	dup rot +
	( total, len b, addr a, addr b )
	heap-alloc
	( addr c, len b, addr a, addr b )
	rot over
	( addr c, addr a, addr c, len a, addr b)
	swap
	( addr a, addr c, addr c, len a, addr b )
	string-copy
	( addr c, addr, lena, addr b )
	dup rot + rot
	( addr b, addr a + len a, addr c)
	string-copy
	( addr c )
;

( Произведение всех простых делителей числа )
( m" solntsev" string-hash 3 % ? - variant 2)
: radical
	dup 1 + ( получаем лимит для цикла, с учетом самого числа, чтобы можно было поделить на само число )
	over
	rot - 1 + ( Вычитаем, чтобы получить 0 и прибавляем 1. Таким образом мы получили начальное значание аккумулятора  )
	swap ( Меняем их местами, чтобы лимит был на вершине )
	dup 1 ( Цикл с начальным индексом 1 и лимитом в 'исходное число + 1'. Лимит продублировали, т.к. он нам потом еще понадобится )
	do
		dup 1 -
		r@ % not if (  Проверяем является ли индекс делителем числа. ![[limit - 1] % index] )
			r@ IsPrime if ( Проверяем делитель на простоту. Если ложь - новая итерация цикла )
				swap ( Меняем местами верхние элементы стека чтобы вытащить радикал )
				r@ * ( Домножаем радикал на простой делитель )
				swap ( Обратно меняем местами радикал и лимит )
			then
		then
	loop
	drop
;