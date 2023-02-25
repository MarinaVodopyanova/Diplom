#Область СлужебныеПроцедурыИФункции
	
Процедура УстановитьЭлементОтбораДинамическогоСписка(СписокОтбора, ЛевоеЗначение, ПравоеЗначение, Использование) Экспорт

	НайденныйЭлементОтбора = Неопределено;
	Для Каждого ЭлементОтбора Из СписокОтбора.Отбор.Элементы Цикл
		Если ЭлементОтбора.ЛевоеЗначение = ЛевоеЗначение Тогда
			НайденныйЭлементОтбора = ЭлементОтбора;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НайденныйЭлементОтбора = Неопределено Тогда
		НайденныйЭлементОтбора = СписокОтбора.Отбор.Элементы.Добавить(
		Тип("ЭлементОтбораКомпоновкиДанных"));
		НайденныйЭлементОтбора.ЛевоеЗначение = ЛевоеЗначение;
	КонецЕсли;
	
	НайденныйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	НайденныйЭлементОтбора.ПравоеЗначение = ПравоеЗначение;
	НайденныйЭлементОтбора.Использование = Использование;
	
КонецПроцедуры	

#КонецОбласти