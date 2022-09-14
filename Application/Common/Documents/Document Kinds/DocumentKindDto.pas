unit DocumentKindDto;

interface

uses

  SysUtils,
  DocumentKinds,
  Classes;

type

  TDocumentKindDto = class;
  
  TDocumentKindDtoClass = class of TDocumentKindDto;

  TDocumentKindDto = class

    public

      Id: Variant;
      TopLevelDocumentKindId: Variant;
      Name: String;
      ServiceType: TDocumentKindClass;

      constructor Create; virtual;

      function Clone: TDocumentKindDto; virtual;
       
  end;

  TDocumentKindDtos = class;

  TDocumentKindDtosEnumerator = class (TListEnumerator)

    protected

      function GetCurrentDocumentKindDto: TDocumentKindDto; virtual;

    public

      constructor Create(DocumentKindDtos: TDocumentKindDtos);

      property Current: TDocumentKindDto read GetCurrentDocumentKindDto;

  end;

  TDocumentKindDtos = class (TList)

    protected

      function GetDocumentKindDtoByIndex(Index: Integer): TDocumentKindDto;

      procedure SetDocumentKindDtoByIndex(
        Index: Integer;
        const Value: TDocumentKindDto
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function Add(DocumentKindDto: TDocumentKindDto): Integer;
      procedure Remove(DocumentKindDto: TDocumentKindDto);

      function FindById(const DocumentKindId: Variant): TDocumentKindDto;
      function FindByIdOrRaise(const DocumentKindId: Variant): TDocumentKindDto;
      function FindByServiceType(const DocumentKindClass: TDocumentKindClass): TDocumentKindDto;
      function FindByServiceTypeOrRaise(const DocumentKindClass: TDocumentKindClass): TDocumentKindDto;
      function IsEmpty: Boolean;
      
      function GetEnumerator: TDocumentKindDtosEnumerator; virtual;

      property Items[Index: Integer]: TDocumentKindDto
      read GetDocumentKindDtoByIndex
      write SetDocumentKindDtoByIndex; default;

  end;

implementation

uses

  Variants;
  
{ TDocumentKindDto }

function TDocumentKindDto.Clone: TDocumentKindDto;
begin

  Result := TDocumentKindDtoClass(ClassType).Create;

  Result.Id := Id;
  Result.TopLevelDocumentKindId := TopLevelDocumentKindId;
  Result.Name := Name;
  Result.ServiceType := ServiceType;
  
end;

constructor TDocumentKindDto.Create;
begin

  inherited;

  Id := Null;
  TopLevelDocumentKindId := Null;
  
end;

{ TDocumentKindDtosEnumerator }

constructor TDocumentKindDtosEnumerator.Create(
  DocumentKindDtos: TDocumentKindDtos);
begin

  inherited Create(DocumentKindDtos);

end;

function TDocumentKindDtosEnumerator.GetCurrentDocumentKindDto: TDocumentKindDto;
begin

  Result := TDocumentKindDto(GetCurrent);
  
end;

{ TDocumentKindDtos }

function TDocumentKindDtos.Add(DocumentKindDto: TDocumentKindDto): Integer;
begin

  Result := inherited Add(DocumentKindDto);
  
end;

function TDocumentKindDtos.FindById(
  const DocumentKindId: Variant): TDocumentKindDto;
begin

  for Result in Self do
    if Result.Id = DocumentKindId then
      Exit;

  Result := nil;
  
end;

function TDocumentKindDtos.FindByIdOrRaise(
  const DocumentKindId: Variant): TDocumentKindDto;
begin

  Result := FindById(DocumentKindId);

  if not Assigned(Result) then begin

    raise Exception.Create(
      'Соответствующий DocumentKindDto не найден'
    );
    
  end;

end;

function TDocumentKindDtos.FindByServiceType(
  const DocumentKindClass: TDocumentKindClass
): TDocumentKindDto;
begin

  for Result in Self do
    if Result.ServiceType = DocumentKindClass then
      Exit;

  Result := nil;

end;

function TDocumentKindDtos.FindByServiceTypeOrRaise(
  const DocumentKindClass: TDocumentKindClass): TDocumentKindDto;
begin

  Result := FindByServiceType(DocumentKindClass);

  if not Assigned(Result) then begin

    raise Exception.Create(
      'DocumentKindDto не найден по сервисному типу документов'
    );
    
  end;

end;

function TDocumentKindDtos.GetDocumentKindDtoByIndex(
  Index: Integer): TDocumentKindDto;
begin

  Result := TDocumentKindDto(Get(Index));

end;

function TDocumentKindDtos.GetEnumerator: TDocumentKindDtosEnumerator;
begin

  Result := TDocumentKindDtosEnumerator.Create(Self);
  
end;

function TDocumentKindDtos.IsEmpty: Boolean;
begin

  Result := Count = 0;
  
end;

procedure TDocumentKindDtos.Notify(Ptr: Pointer; Action: TListNotification);
begin

  inherited;

  if (Action = lnDeleted) and Assigned(Ptr) then
    TDocumentKindDto(Ptr).Destroy;

end;

procedure TDocumentKindDtos.Remove(DocumentKindDto: TDocumentKindDto);
begin

  inherited Remove(DocumentKindDto);

end;

procedure TDocumentKindDtos.SetDocumentKindDtoByIndex(Index: Integer;
  const Value: TDocumentKindDto);
begin

  Put(Index, Value);
  
end;

end.

