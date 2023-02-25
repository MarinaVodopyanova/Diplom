#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы  = "ФормаОбъекта" Тогда
		СтандартнаяОбработка = Ложь;
		Если ПравоДоступа("Администрирование",Метаданные,,) Тогда
			ВыбраннаяФорма = Метаданные.Справочники.Сотрудники.Формы.ФормаАдминистратора;
		Иначе
			ВыбраннаяФорма = Метаданные.Справочники.Сотрудники.Формы.ФормаПользователя;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти