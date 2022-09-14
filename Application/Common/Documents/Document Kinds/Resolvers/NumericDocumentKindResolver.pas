unit NumericDocumentKindResolver;

interface

uses

  DocumentKindResolver,
  DocumentKinds,
  SysUtils,
  Classes;

type

  TNumericDocumentKindResolver = class (TInterfacedObject, IDocumentKindResolver)

    public

      function ResolveIdForDocumentKind(
        DocumentKind: TDocumentKindClass
      ): Variant; virtual;

      function ResovleDocumentKindById(
        const DocumentKindId: Variant
      ): TDocumentKindClass; virtual;
      
  end;
  
implementation

{ TNumericDocumentKindResolver }

function TNumericDocumentKindResolver.ResolveIdForDocumentKind(
  DocumentKind: TDocumentKindClass
): Variant;
begin

  if DocumentKind = TServiceNoteKind then
    Result := 1

  else if DocumentKind = TOutcomingServiceNoteKind then
    Result := 2

  else if DocumentKind = TIncomingServiceNoteKind then
    Result := 3

  else if DocumentKind = TApproveableServiceNoteKind then
    Result := 4

  else if DocumentKind = TInternalServiceNoteKind then
    Result := 5

  else if DocumentKind = TOutcomingInternalServiceNoteKind then
    Result := 6
    
  else if DocumentKind = TIncomingInternalServiceNoteKind then
    Result := 7

  else if DocumentKind = TPersonnelOrderKind then
    Result := 11

  else if DocumentKind = TOrderKind then
    Result := 8
    
  else raise Exception.Create(
                'Не удалось определить идентификатор ' +
                'вида документа'
             );
       
end;

function TNumericDocumentKindResolver.
  ResovleDocumentKindById(
    const DocumentKindId: Variant
  ): TDocumentKindClass;
begin

  case DocumentKindId of

    1: Result := TServiceNoteKind;
    2: Result := TOutcomingServiceNoteKind;
    3: Result := TIncomingServiceNoteKind;
    4: Result := TApproveableServiceNoteKind;
    5: Result := TInternalServiceNoteKind;
    6: Result := TOutcomingInternalServiceNoteKind;
    7: Result := TIncomingInternalServiceNoteKind;
    8: Result := TOrderKind;
    11: Result := TPersonnelOrderKind;

    else begin

      raise Exception.Create(
        'Программная ошибка. ' +
        'Не удалось по идентификатору ' +
        'определить соответствующий вид документов'
      );

    end;

  end;
  
end;

end.
