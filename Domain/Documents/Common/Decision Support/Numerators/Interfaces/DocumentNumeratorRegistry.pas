unit DocumentNumeratorRegistry;

interface

uses

  StandardDocumentNumerator,
  DomainException,
  Department,
  Document;

type

  TDocumentNumeratorRegistryException = class (TDomainException)
  
  end;

  {
    refactor: исключить необходимость использовать
    подразделение для поиска нумератора типа документа в этом
    подразделении. Изменить сигнатуру метода на
    function (Document: TDocument): TDocumentNumerator;
    Для документа находить соответствующий нумератор
    в зависимости от его типа. Например, для служебных
    записок поиск нумератора будет включать тип документа и
    подразделение подписанта (возможно, внедрять службу,
    которая будет определять нужное подразделение); для
    кадровых приказов возвращать nil или же выбрасывать исключение
    об отсутствии нумераторов (добавить в службу ещё один идентичный метод,
    но с приставкой OrRaise - будет выбрасывать исключение в случае,
    если нумератор не найден); в других случаях поиск будет
    включать только тип документа. Определение того, каким образом
    выполнять поиск (использовать подразделение подписанта или нет),
    должно быть реализовано в другой внедряемой службе
  }

  IDocumentNumeratorRegistry = interface

    function GetDocumentNumeratorFor(
      DocumentType: TDocumentClass;
      const DepartmentId: Variant
    ): TDocumentNumerator;

  end;

implementation

end.
