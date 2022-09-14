unit DocumentTypeDBResolver;

interface

uses

  Document,
  SysUtils,
  Hashes,
  Classes;

type

  TDocumentTypeDBResolverException = class (Exception)

  end;

  IDocumentTypeDBResolver = interface

    function ResolveDocumentType(const ServiceDocumentTypeName: String): TDocumentClass;
    function ResolveServiceNameForDocumentType(DocumentType: TDocumentClass): String;

  end;

  TDocumentTypeDBResolver = class (TInterfacedObject, IDocumentTypeDBResolver)

    private

      FDocumentTypeMap: TObjectHash;
      FServiceNameMap: TStringHash;

    private

      procedure CreateMaps;
      procedure CreateServiceNameMap;
      procedure CreateDocumentTypeMap;

    private

      procedure SetDocumentType(const ServiceName: String; DocumentType: TDocumentClass);
      function GetDocumentTypeOrRaise(const ServiceName: String): TDocumentClass;
        
    public

      destructor Destroy; override;
      constructor Create;

      function ResolveDocumentType(const ServiceDocumentTypeName: String): TDocumentClass;
      function ResolveServiceNameForDocumentType(DocumentType: TDocumentClass): String;
      
  end;

implementation

uses

  ClassHolder,
  VariantTypeUnit,
  ServiceNote,
  InternalServiceNote,
  IncomingServiceNote,
  IncomingInternalServiceNote,
  PersonnelOrder;

const

  SERVICE_NOTE_SERVICE_NAME = 'service_note';
  INCOMING_SERVICE_NOTE_SERVICE_NAME = 'incoming_service_note';
  PERSONNEL_ORDER_SERVICE_NAME = 'personnel_order';
  
{ TDocumentTypeDBResolver }

constructor TDocumentTypeDBResolver.Create;
begin

  inherited;

  CreateMaps;
  
end;

procedure TDocumentTypeDBResolver.CreateMaps;
begin

  CreateDocumentTypeMap;
  CreateServiceNameMap;

end;

procedure TDocumentTypeDBResolver.CreateDocumentTypeMap;
begin

  FDocumentTypeMap := TObjectHash.Create;

  SetDocumentType(SERVICE_NOTE_SERVICE_NAME, TServiceNote);
  SetDocumentType(INCOMING_SERVICE_NOTE_SERVICE_NAME, TIncomingServiceNote);
  SetDocumentType(PERSONNEL_ORDER_SERVICE_NAME, TPersonnelOrder);

end;

procedure TDocumentTypeDBResolver.CreateServiceNameMap;
begin

  FServiceNameMap := TStringHash.Create;

  FServiceNameMap[TServiceNote.ClassName] := SERVICE_NOTE_SERVICE_NAME;
  FServiceNameMap[TIncomingServiceNote.ClassName] := INCOMING_SERVICE_NOTE_SERVICE_NAME;
  FServiceNameMap[TPersonnelOrder.ClassName] := PERSONNEL_ORDER_SERVICE_NAME;

end;

destructor TDocumentTypeDBResolver.Destroy;
begin

  FreeAndNil(FDocumentTypeMap);
  FreeAndNil(FServiceNameMap);

  inherited;

end;

function TDocumentTypeDBResolver.ResolveDocumentType(
  const ServiceDocumentTypeName: String
): TDocumentClass;
begin

  Result := GetDocumentTypeOrRaise(ServiceDocumentTypeName);

end;

function TDocumentTypeDBResolver.GetDocumentTypeOrRaise(
  const ServiceName: String): TDocumentClass;
begin

  if not FDocumentTypeMap.Exists(ServiceName) then begin

    Raise TDocumentTypeDBResolverException.Create(
      'Программная ошибка. Не удалось определить тип документа ' +
      'по служебному наименованию'
    );

  end;

  Result :=
    TDocumentClass(TClassHolder(FDocumentTypeMap[ServiceName]).ClassValue);

end;

procedure TDocumentTypeDBResolver.SetDocumentType(const ServiceName: String;
  DocumentType: TDocumentClass);
begin

  FDocumentTypeMap[ServiceName] := TClassHolder.Create(DocumentType);
  
end;

function TDocumentTypeDBResolver.ResolveServiceNameForDocumentType(
  DocumentType: TDocumentClass): String;
begin

  if not FServiceNameMap.Exists(DocumentType.ClassName) then begin

    Raise TDocumentTypeDBResolverException.Create(
      'Программная ошибка. Не удалось определить ' +
      'служебное наименование типа документа'
    );

  end;

  Result := FServiceNameMap[DocumentType.ClassName];
  
end;

end.
