unit NumericDocumentKindIdResolver;

interface

uses

  DocumentKindIdResolver,
  DocumentKinds,
  SysUtils,
  Classes;

type

  TNumericDocumentKindIdResolver = class (TInterfacedObject, IDocumentKindIdResolver)

    public

      function ResolveIdForDocumentKind(
        DocumentKind: TDocumentKindClass
      ): Variant; virtual;

      function ResolveIdForDocumentKindAsApproveable(
        DocumentKind: TDocumentKindClass
      ): Variant; virtual;
      
  end;
  
implementation

{ TNumericDocumentKindIdResolver }

function TNumericDocumentKindIdResolver.ResolveIdForDocumentKind(
  DocumentKind: TDocumentKindClass): Variant;
begin

  if DocumentKind = TServiceNoteKind then
    Result := 2

  else if DocumentKind = TIncomingServiceNoteKind then
    Result := 3

  else if DocumentKind = TApproveableServiceNoteKind then
    Result := 4
    
  else raise Exception.Create(
                'Ќе удалось определить идентификатор ' +
                'вида документа'
             );
       
end;

function TNumericDocumentKindIdResolver.
  ResolveIdForDocumentKindAsApproveable(
    DocumentKind: TDocumentKindClass
  ): Variant;
begin

  { refactor: абстракный базовый класс создать,
    в котором бы провер€лось какие виды документов
    могут быть согласемыми
  }
  if DocumentKind.InheritsFrom(TIncomingDocumentKind) then
    raise Exception.Create(
      'ѕопытка определени€ идентификатора ' +
      'вход€щего вида документов в качестве ' +
      'согласуемого'
    );

  if not DocumentKind.InheritsFrom(TOutcomingDocumentKind) then
    raise Exception.Create(
      'ƒл€ определени€ идентификатора ' +
      'вида документов в качестве согласуемого ' +
      'должен быть передан исход€щий вид документов'
    );

  if DocumentKind = TServiceNoteKind then
    Result := 4

  else
    raise Exception.Create(
      'ќпределение идентификатора ' +
      'дл€ затребованного вида документов ' +
      'в качестве согласуемого ' +
      'не реализовано'
    );
  
end;

end.
