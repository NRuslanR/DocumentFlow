unit DocumentKindsMapper;

interface

uses

  IGetSelfUnit,
  DocumentKinds,
  Document,
  SysUtils,
  Classes;

type

  TDocumentKindsMapperException = class (Exception)

  end;

  IDocumentKindsMapper = interface (IGetSelf)
    ['{A4CFA6FE-D701-4C30-A824-509439B88DC8}']

    function MapDocumentKindToDomainDocumentKind(
      const DocumentKind: TDocumentKindClass
    ): TDocumentClass;

    function MapDomainDocumentKindToDocumentKind(
      const DocumentClass: TDocumentClass
    ): TDocumentKindClass;

  end;

  
  TDocumentKindsMapper = class (TInterfacedObject, IDocumentKindsMapper)

    public

      function GetSelf: TObject;

      function MapDocumentKindToDomainDocumentKind(
        const DocumentKind: TDocumentKindClass
      ): TDocumentClass;

      function MapDomainDocumentKindToDocumentKind(
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

function TDocumentKindsMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentKindsMapper.
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
      '����������� ������. ' +
      '�� ������� ���������� �������� ��� ' +
      '���������� �� ���������� ���� ' +
      '���������� %s',
      [DocumentKind.ClassName]
    );

  end;

end;

function TDocumentKindsMapper.MapDomainDocumentKindToDocumentKind(
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
      '����������� ������. �� ������� ' +
      '���������� ��������� ��� ���������� ' +
      '�� ��������� ���� ���������� %s',
      [DocumentClass.ClassName]
    );
    
  end;

end;

end.
