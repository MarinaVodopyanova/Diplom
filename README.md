## Дипломный проект

Конфигурация с именем «УправлениеИТФирмой» из диплома блока А, дополненная.

В существующей подсистеме настройки:

* перечислением **«ТипыНоменклатуры»** («Товар», «Услуга»);

* перечислением **«СтавкиНДС»** («БезНДС», «НДС10», «НДС20»);

* справочником **«НоменклатурныеГруппы»**
   * без иерархии, с наименованием разумной длины;

* справочником **«Номенклатура»**, который:
   * имеет наименование разумной длины и неограниченную иерархию групп и элементов;
   * содержит реквизиты «Тип», «СтавкаНДС» и «НоменклатурнаяГруппа», используемые для элементов и обязательные к заполнению;

* документом **«УстановкаЦен»**, который:
   * содержит реквизит шапки «Ответственный» и табличную часть «Цены» с реквизитами «Номенклатура» и «Цена»;
   * имеет форму, в которой реализованы:
      * выбор и подбор номенклатуры с автоматическим назначением цен согласно срезу последних регистра сведений «Цены»;
   * формирует движения по регистру сведений **«Цены»**;
   
* регистром сведений **«Цены»**, который:
   * содержит измерение «Номенклатура» и ресурс «Цена»;
   * является периодическим с подчинением регистратору (документу **«УстановкаЦен»**);

* документом **«УстановкаСкидок»**, который:
   * содержит реквизит шапки «Ответственный» и табличную часть «Скидки» с реквизитами «НоменклатураНоменклатурнаяГруппа» и «Скидка»;
   * имеет форму, в которой реализованы:
      * выбор номенклатуры и номенклатурных групп с автоматическим назначением скидок согласно срезу последних регистра сведений «Скидки»;
   * формирует движения по регистру сведений **«Скидки»**;
   
* регистром сведений **«Скидки»**, который:
   * содержит измерение «НоменклатураНоменклатурнаяГруппа» и ресурс «Скидка»;
   * является периодическим с подчинением регистратору (документу **«УстановкаСкидок»**);
   
* журналом документов **«ЦеныИСкидки»**, который:
   * содержит документы **«УстановкаЦен»** и **«УстановкаСкидок»** и графу «Ответственный».

Подсистемой **«Сделки»**, а в ней:

* документом **«ПоступлениеТоваровИУслуг»**, который:
   * содержит реквизиты шапки «Поставщик», «Ответственный», «Сумма» и табличную часть «ТоварыИУслуги» с реквизитами «Номенклатура», «Количество», «Цена», «Сумма», «СтавкаНДС», «СуммаНДС»;
   * имеет форму, в которой реализован выбор и подбор номенклатуры с автоматическим пересчётом числовых колонок по правилам:
      * при изменении реквизитов «Количество» и «Цена» пересчитывается «Сумма» и «СуммаНДС» (см. ниже «Правила расчёта НДС»);
      * при изменении реквизита «Сумма» пересчитывается «Цена» и «СуммаНДС»;
      * при изменении реквизита «СтавкаНДС» пересчитывается «СуммаНДС»;
   * перед записью заполняет реквизит шапки «Сумма» итогом по одноимённой колонке табличной части;
   * формирует движения:
      * расход по регистру накопления **«ВзаиморасчетыСКонтрагентами»** с указанием поставщика в сумме общего итога по реквизиту ТЧ «Сумма»;
      * приход по регистру накопления **«Товары»** в разрезе номенклатуры типа «Товар» согласно реквизитам ТЧ «Количество» и «Сумма»;
      * движения по регистру накопления **«Расходы»** в разрезе номенклатуры типа «Услуга» согласно реквизиту ТЧ «Сумма»;

* документом **«РеализацияТоваровИУслуг»**, который:
   * содержит реквизит шапки «Покупатель», «Ответственный», «Сумма» и табличную часть «ТоварыИУслуги» с реквизитами «Номенклатура», «Количество», «Скидка», «Цена», «Сумма», «СтавкаНДС», «СуммаНДС»;
   * имеет форму, в которой реализован выбор и подбор номенклатуры с автоматическим назначением цены и скидки, а также пересчётом числовых колонок по правилам:
      * при изменении реквизитов «Количество» и «Цена» пересчитывается «Сумма» с учётом скидки и «СуммаНДС» (см. ниже «Правила расчёта НДС»);
      * при изменении реквизита «Скидка» пересчитывается «Сумма» и «СуммаНДС» (см. ниже «Применение скидок»);
      * при изменении реквизита «Сумма» пересчитывается «СуммаНДС»;
      * при изменении реквизита «СтавкаНДС» пересчитывается «СуммаНДС»;
   * перед записью заполняет реквизит шапки «Сумма» итогом по одноимённой колонке табличной части;
   * формирует движения:
      * приход по регистру накопления **«ВзаиморасчетыСКонтрагентами»** с указанием покупателя в сумме общего итога по реквизиту ТЧ «Сумма»;
      * расход по регистру накопления **«Товары»** в разрезе номенклатуры типа «Товар» согласно реквизиту ТЧ «Количество» и сумме, определённой согласно средней стоимости остатков этого товара. В отсутствие достаточного остатка проведение не выполняется;
      * движения по регистру накопления **«Расходы»** в разрезе номенклатуры типа «Товар» в сумме себестоимости продаж (сумме расхода по регистру «Товары»);
      * движения по регистру накопления **«Доходы»** в разрезе номенклатуры всех типов согласно реквизиту ТЧ «Сумма»;
      
* журналом документов **«Сделки»**, который:
   * содержит документы **«ПоступлениеТоваровИУслуг»** и **«РеализацияТоваровИУслуг»** с графами «Контрагент», «Ответственный» и «Сумма».

Подсистемой **«Деньги»**, а в ней:

* документом **«ПоступлениеДенежныхСредств»**, который:
  * содержит реквизиты «Плательщик» и «Сумма»;
  * формирует движение: расход по регистру накопления **«ВзаиморасчетыСКонтрагентами»** с указанием плательщика и суммы;

* документом **«СписаниеДенежныхСредств»**, который:
  * содержит реквизиты «Получатель» и «Сумма»;
  * формирует движение: приход по регистру накопления **«ВзаиморасчетыСКонтрагентами»** с указанием получателя и суммы;
  
* журналом документов **«Деньги»**, который:
   * содержит документы **«ПоступлениеДенежныхСредств»** и **«СписаниеДенежныхСредств»** с графами «Контрагент», «Ответственный» и «Сумма»;

* регистром накопления **«ВзаиморасчетыСКонтрагентами»**, который:
  * имеет вид «Остатки»;
  * содержит измерение «Контрагент» и ресурс «Сумма»;
  * подчинён регистраторам **«ПоступлениеТоваровИУслуг»**, **«РеализацияТоваровИУслуг»**, **«ПоступлениеДенежныхСредств»**, **«РасходованиеДенежныхСредств»**;
  * положительные остатки по нему означают дебиторскую задолженность (нам должны), отрицательные — кредиторскую (мы должны);
      
* регистром накопления **«Товары»**, который:
  * имеет вид «Остатки»;
  * содержит измерение «Номенклатура» и ресурсы «Количество», «Сумма»;
  * подчинён регистраторам **«ПоступлениеТоваровИУслуг»** и **«РеализацияТоваровИУслуг»**;
  * хранит текущие остатки товаров и их себестоимость с учётом НДС;
  
* регистром накопления **«Доходы»**, который:
  * имеет вид «Обороты»;
  * содержит измерение «Номенклатура» и ресурсы «Количество», «Сумма»;
  * подчинён регистратору **«РеализацияТоваровИУслуг»**;
  * хранит доходы (выручку) от реализации товаров и услуг с учётом НДС;
  
* регистром накопления **«Расходы»**, который:
  * имеет вид «Обороты»;
  * содержит измерение «Номенклатура» и ресурсы «Количество», «Сумма»;
  * подчинён регистраторам **«ПоступлениеТоваровИУслуг»**, **«РеализацияТоваровИУслуг»**;
  * хранит расходы по приобретённым услугам и себестоимость реализованных товаров с учётом НДС;
  
* отчётом **«ДоходыИРасходы»**, который:
  * выводит, соединяя, данные регистров **«Доходы»** и **«Расходы»** в три колонки: «Доходы», «Расходы», «Прибыль»;
  * содержит группировку по номенклатуре с учётом иерархии и общие итоги;
  
* отчётом **«ДвижениеТоваров»**, который:
  * выводит данные регистра **«Товары»**: остатки и обороты по количеству и сумме;
  * содержит группировку по номенклатуре с учётом иерархии и общие итоги;
  * не суммирует количества в общем итоге и по иерархии номенклатуры;
  
* отчётом **«ВзаиморасчетыСКонтрагентами»**, который:
  * выводит данные регистра **«ВзаиморасчетыСКонтрагентами»**: остатки и обороты;
  * содержит группировку по контрагентам и общие итоги.
  
Ценообразование должно быть доступно только роли **«ПолныеПрава»**.

### Применение скидок

Скидки определяются по срезу последних регистра сведений «Скидки». Если скидка установлена и на конкретный элемент справочника **«Номенклатура»**, и на номенклатурную группу, приоритет имеет скидка для конкретного элемента.

Цена определяется по данным регистра сведений «Цены» и не пересчитывается при изменении скидки. Сумма определяется по цене с учётом скидки как:
   Сумма = Количество * Цена * (100 − Скидка) / 100
При изменении суммы изменяется скидка, но не цена, по обратной формуле:
   Скидка = 100 * (1 − Сумма / Количество / Цена)

### Правила расчёта НДС

НДС рассчитывается по ставкам, определяемым по значению перечисления **«СтавкиНДС»** (БезНДС — 0%, НДС10 — 10%, НДС20 — 20%). Сумма НДС определяется умножением суммы на ставку, то есть НДС рассчитывается по схеме «в том числе», например, для ставки 20% и суммы 120 р сумма НДС будет равна 120 * 0.2 / (1 + 0.2) = 20.