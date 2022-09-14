unit DocumentKindsMapper;

interface

uses

  DocumentKinds,
  Document,
  SysUtils,
  Classes;

type

  TDocumentKindsMapperException = class (Exception)

  end;
  
  TDocumentKindsMapper = class

    public

      class function MapDocumentKindToDomainDocumentKind(
        const DocumentKind: TDocumentKindClass
      ): TDocumentClass;

      class function MapDomainDocumentKindToDocumentKind(
        const DocumentClass: TDocumentClass
      ): TDocumentKindClass;

  end;

implementation

uses

  ServiceNote,
  PersonnelOrder,
  IncomingServiceNote,
  InternalServiceNote,
  IncomingInternalServiceNote;
  
{ TDocumentKindsMapper }

class function TDocumentKindsMapper.
  MapDocumentKindToDomainDocumentKind(
    const DocumentKind: TDocumentKindClass
  ): TDocumentClass;
begin

  if (DocumentKind = TOutcomingServiceNoteKind) or
     (DocumentKind = TApproveableServiceNoteKind)
  then
    Result := TServiceNote

  else if DocumentKind = TIncomingServiceNoteKind then
    Result := TIncomingServiceNote

  else if DocumentKind = TOutcomingInternalServiceNoteKind then
    Result := TInternalServiceNote

  else if DocumentKind = TIncomingInternalServiceNoteKind then
    Result := TIncomingInternalServiceNote

  else if DocumentKind = TPersonnelOrderKind then
    Result := TPersonnelOrder

  else begin
  
    raise TDocumentKindsMapperException.CreateFmt(
      'Программная ошибка. ' +
      'Не удалось определить доменный вид ' +
      'документов по сервисному виду ' +
      'документов %s',
      [DocumentKind.ClassName]
    );

  end;

end;

class function TDocumentKindsMapper.MapDomainDocumentKindToDocumentKind(
  const DocumentClass: TDocumentClass): TDocumentKindClass;
begin

  if DocumentClass = TServiceNote then
    Result := TOutcomingServiceNoteKind

  else if DocumentClass = TIncomingServiceNote then
    Result := TIncomingServiceNoteKind

  else if DocumentClass = TInternalServiceNote then
    Result := TOutcomingInternalServiceNoteKind

  else if DocumentClass = TIncomingInternalServiceNote then
    Result := TIncomingInternalServiceNoteKind

  else if DocumentClass = TPersonnelOrder then
    Result := TPersonnelOrderKind
    
  else begin

    raise TDocumentKindsMapperException.CreateFmt(
      'Программная ошибка. Не удалось ' +
      'определить сервисный вид документов ' +
      'по доменному виду документов %s',
      [DocumentClass.ClassName]
    );
    
  end;

end;

end.
