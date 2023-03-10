#Область СлужебныеПроцедурыИФункции

Функция ЦенаНаДату(Номенклатура, Дата) Экспорт
	Запрос = Новый Запрос;
	МоментВремени = Новый МоментВремени(Дата);
	Запрос.Текст = "ВЫБРАТЬ
	|	ЦеныСрезПоследних.Номенклатура КАК Номенклатура,
	|	ЦеныСрезПоследних.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.Цены.СрезПоследних(&Дата, Номенклатура = &Номенклатура) КАК ЦеныСрезПоследних";
	
	Запрос.УстановитьПараметр("Дата", МоментВремени);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	РезультатЗапрса = Запрос.Выполнить();
	Если РезультатЗапрса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Цена;
	КонецЦикла;
КонецФункции

////1. Вариант решения.

Функция СкидкаНаДату(Номенклатура, Дата) Экспорт
	
	Запрос = Новый Запрос;
	МоментВремени = Новый МоментВремени(Дата);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СкидкиСрезПоследних.НоменклатураНоменклатурнаяГруппа КАК НоменклатураНоменклатурнаяГруппа,
	               |	СкидкиСрезПоследних.Скидка КАК Скидка
	               |ИЗ
	               |	РегистрСведений.Скидки.СрезПоследних(&Дата, НоменклатураНоменклатурнаяГруппа = &Номенклатура) КАК СкидкиСрезПоследних";
	
	Запрос.УстановитьПараметр("Дата", МоментВремени);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
			Если Выборка.НоменклатураНоменклатурнаяГруппа <> Неопределено Тогда
				Возврат Выборка.Скидка;
			КонецЕсли;
	КонецЦикла;
	
	Если РезультатЗапроса.Пустой() И ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
		Запрос.УстановитьПараметр("Дата", МоментВремени);
		Запрос.УстановитьПараметр("Номенклатура", Номенклатура.НоменклатурнаяГруппа);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.НоменклатураНоменклатурнаяГруппа <> Неопределено Тогда
				Возврат Выборка.Скидка;
			КонецЕсли;	
		КонецЦикла;
		
		Возврат Неопределено;
КонецФункции

#КонецОбласти

////2. Вариант решения. Как правильнее??

//Функция СкидкаНаДату(Номенклатура, Дата) Экспорт
//	
//	Запрос = Новый Запрос;
//	МоментВремени = Новый МоментВремени(Дата);
//	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
//	
//	Запрос.Текст = "ВЫБРАТЬ
//	|	СкидкиСрезПоследних.НоменклатураНоменклатурнаяГруппа КАК НоменклатураНоменклатурнаяГруппа,
//	|	СкидкиСрезПоследних.Скидка КАК Скидка
//	|ПОМЕСТИТЬ ВТ_СкидкаНоменклатуры
//	|ИЗ
//	|	РегистрСведений.Скидки.СрезПоследних(&Дата, НоменклатураНоменклатурнаяГруппа = &Номенклатура) КАК СкидкиСрезПоследних
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|ВЫБРАТЬ
//	|	СкидкиСрезПоследних.НоменклатураНоменклатурнаяГруппа КАК НоменклатураНоменклатурнаяГруппа,
//	|	СкидкиСрезПоследних.Скидка КАК Скидка
//	|ПОМЕСТИТЬ ВТ_СкидкиГруппы
//	|ИЗ
//	|	РегистрСведений.Скидки.СрезПоследних(&Дата, НоменклатураНоменклатурнаяГруппа = &НоменклатурнаяГруппа) КАК СкидкиСрезПоследних";
//	
//	Запрос.УстановитьПараметр("Дата", МоментВремени);
//	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
//	
//	Если ТипЗнч(Номенклатура) = Тип("СправочникСсылка.НоменклатурныеГруппы") Тогда
//		Запрос.УстановитьПараметр("НоменклатурнаяГруппа", Номенклатура);
//	Иначе
//		Запрос.УстановитьПараметр("НоменклатурнаяГруппа", Номенклатура.НоменклатурнаяГруппа);
//	КонецЕсли;
//	
//	РезультатЗапроса = Запрос.Выполнить();
//	
//	Если РезультатЗапроса.Пустой() Тогда
//		Возврат Неопределено;
//	КонецЕсли;
//	
//	ВыборкаСкидкаНоменклатурыИлиГруппы = Запрос.МенеджерВременныхТаблиц.Таблицы.Получить(0).ПолучитьДанные().Выбрать();
//	ВыборкаСкидкиГруппыНоменклатурыБезСкидки = Запрос.МенеджерВременныхТаблиц.Таблицы.Получить(1).ПолучитьДанные().Выбрать();
//	
//	Пока ВыборкаСкидкаНоменклатурыИлиГруппы.Следующий() Цикл
//		Если ВыборкаСкидкаНоменклатурыИлиГруппы.НоменклатураНоменклатурнаяГруппа <> Неопределено Тогда
//			Возврат ВыборкаСкидкаНоменклатурыИлиГруппы.Скидка;
//		КонецЕсли;	
//	КонецЦикла;
//	
//	Пока ВыборкаСкидкиГруппыНоменклатурыБезСкидки.Следующий() Цикл
//		Если ВыборкаСкидкиГруппыНоменклатурыБезСкидки.НоменклатураНоменклатурнаяГруппа <> Неопределено Тогда
//			Возврат ВыборкаСкидкиГруппыНоменклатурыБезСкидки.Скидка;
//		КонецЕсли;	
//	КонецЦикла;
//	
//	Если ВыборкаСкидкиГруппыНоменклатурыБезСкидки.НоменклатураНоменклатурнаяГруппа <> Неопределено Тогда
//		Возврат ВыборкаСкидкиГруппыНоменклатурыБезСкидки.Скидка;
//	КонецЕсли;
//	
//КонецФункции



