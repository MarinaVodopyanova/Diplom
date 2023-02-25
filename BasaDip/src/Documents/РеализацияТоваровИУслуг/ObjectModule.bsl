#Область ОбработчикиСобытий
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка = Истина Тогда
    Возврат;
КонецЕсли;

	Сумма = ТоварыИУслуги.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Ответственный = ПараметрыСеанса.СотрудникТекущегоПользователя;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Если Проведен Тогда
		Рег = РегистрыНакопления.Товары;
		НаборТовары  = Рег.СоздатьНаборЗаписей();
		НаборТовары.Отбор.Регистратор.Установить(Ссылка);
		НаборТовары.Записать();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	Запрос.Текст = "ВЫБРАТЬ
	               |	РеализацияТоваровИУслугТоварыИУслуги.Номенклатура.Тип КАК НоменклатураТип,
	               |	РеализацияТоваровИУслугТоварыИУслуги.Номенклатура КАК Номенклатура,
	               |	СУММА(РеализацияТоваровИУслугТоварыИУслуги.Количество) КАК Количество,
	               |	СУММА(РеализацияТоваровИУслугТоварыИУслуги.Сумма) КАК Сумма
	               |ПОМЕСТИТЬ ВТ_НоменклатураДокумента
	               |ИЗ
	               |	Документ.РеализацияТоваровИУслуг.ТоварыИУслуги КАК РеализацияТоваровИУслугТоварыИУслуги
	               |ГДЕ
	               |	РеализацияТоваровИУслугТоварыИУслуги.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	РеализацияТоваровИУслугТоварыИУслуги.Номенклатура,
	               |	РеализацияТоваровИУслугТоварыИУслуги.Номенклатура.Тип
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТоварыОстатки.Номенклатура КАК НоменклатураОстаток,
	               |	СУММА(ТоварыОстатки.КоличествоОстаток) КАК КоличествоОстаток,
	               |	СУММА(ТоварыОстатки.СуммаОстаток) КАК СуммаОстаток
	               |ПОМЕСТИТЬ ВТ_ОстаткиНоменклатуры
	               |ИЗ
	               |	РегистрНакопления.Товары.Остатки(&Дата, ) КАК ТоварыОстатки
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТоварыОстатки.Номенклатура
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_НоменклатураДокумента.НоменклатураТип КАК НоменклатураТип,
	               |	ВТ_НоменклатураДокумента.Номенклатура КАК Номенклатура,
	               |	ВТ_НоменклатураДокумента.Количество КАК Количество,
	               |	ВТ_НоменклатураДокумента.Сумма КАК Сумма,
	               |	ВТ_ОстаткиНоменклатуры.НоменклатураОстаток КАК НоменклатураОстаток,
	               |	ВТ_ОстаткиНоменклатуры.КоличествоОстаток КАК КоличествоОстаток,
	               |	ВТ_ОстаткиНоменклатуры.СуммаОстаток КАК СуммаОстаток
	               |ПОМЕСТИТЬ ВТ_Результат
	               |ИЗ
	               |	ВТ_НоменклатураДокумента КАК ВТ_НоменклатураДокумента
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОстаткиНоменклатуры КАК ВТ_ОстаткиНоменклатуры
	               |		ПО ВТ_НоменклатураДокумента.Номенклатура = ВТ_ОстаткиНоменклатуры.НоменклатураОстаток";
	
	Запрос.УстановитьПараметр("Дата", МоментВремени());
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = Запрос.МенеджерВременныхТаблиц.Таблицы.Получить(2).ПолучитьДанные().Выбрать();
	
	Если РезультатЗапроса.Пустой() Тогда
		Для каждого Стр Из ТоварыИУслуги Цикл
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = (СтрШаблон("Товара ""%1"" недостаточно в количестве: %2", Стр.Номенклатура, Стр.Количество));
			Сообщение.Сообщить();
		КонецЦикла;
		Отказ = Истина;
	КонецЕсли;
	
	Движения.Товары.Записывать = Истина;
	Движения.Доходы.Записывать = Истина;
	Движения.Расходы.Записывать = Истина;
	Движения.ВзаиморасчетыСКонтрагентами.Записывать = Истина;
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.НоменклатураТип = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар") Тогда
			
			Если Выборка.КоличествоОстаток = 0 Тогда
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = (СтрШаблон("Товара ""%1"" недостаточно в количестве: %2", Выборка.Номенклатура, Выборка.Количество));
				Сообщение.Сообщить();
				Отказ = Истина;
				
			ИначеЕсли Выборка.КоличествоОстаток - Выборка.Количество < 0  Тогда
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = (СтрШаблон("Товара ""%1"" недостаточно в количестве: %2", Выборка.Номенклатура, (-(Выборка.КоличествоОстаток - Выборка.Количество))));
				Сообщение.Сообщить();
				Отказ = Истина;
				
			Иначе
				Если Выборка.КоличествоОстаток = Выборка.Количество Тогда
					СуммаКСписанию = Выборка.СуммаОстаток;
				Иначе
					СуммаЗаЕдиницу = Выборка.СуммаОстаток / Выборка.КоличествоОстаток;
					СуммаКСписанию = СуммаЗаЕдиницу * Выборка.Количество;
				КонецЕсли;
				
				Движение = Движения.Товары.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.Номенклатура  = Выборка.Номенклатура;
				Движение.Количество = Выборка.Количество;
				Движение.Сумма = СуммаКСписанию;
				
				Движение = Движения.Расходы.Добавить();
				Движение.Период = Дата;
				Движение.Номенклатура  = Выборка.Номенклатура;
				Движение.Сумма = СуммаКСписанию;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Движение = Движения.Доходы.Добавить();
		Движение.Период = Дата;
		Движение.Номенклатура  = Выборка.Номенклатура;
		Движение.Количество = Выборка.Количество;
		Движение.Сумма = Выборка.Сумма;
		
		Движение = Движения.ВзаиморасчетыСКонтрагентами.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Контрагент = Покупатель;
		Движение.Сумма = Сумма;
		
	КонецЦикла;
КонецПроцедуры

#КонецОбласти