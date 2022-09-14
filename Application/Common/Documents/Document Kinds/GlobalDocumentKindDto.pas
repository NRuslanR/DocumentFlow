unit GlobalDocumentKindDto;

interface

uses

  SysUtils,
  DocumentKindDto,
  NativeDocumentKindDto,
  DocumentKinds,
  Classes;

type

  TGlobalDocumentKindDto = class (TDocumentKindDto)

    public

      WorkingId: Variant;
      TopLevelWorkingDocumentKindId: Variant;
      
      constructor Create; override;

      function ToNativeDocumentKindDto: TNativeDocumentKindDto;
      function Clone: TDocumentKindDto; override;
       
  end;

  TGlobalDocumentKindDtos = class;

  TGlobalDocumentKindDtosEnumerator = class (TDocumentKindDtosEnumerator)

    private

      function GetCurrentGlobalDocumentKindDto: TGlobalDocumentKindDto;

    protected

      function GetCurrentDocumentKindDto: TDocumentKindDto; override;

    public

      constructor Create(GlobalDocumentKindDtos: TGlobalDocumentKindDtos);

      property Current: TGlobalDocumentKindDto read GetCurrentGlobalDocumentKindDto;

  end;

  TGlobalDocumentKindDtos = class (TDocumentKindDtos)

    private

      function GetGlobalDocumentKindDtoByIndex(Index: Integer): TGlobalDocumentKindDto;

      procedure SetGlobalDocumentKindDtoByIndex(
        Index: Integer;
        const Value: TGlobalDocumentKindDto
      );
      
      procedure Notify(Ptr: Pointer; Action: TListNotification);

    public

      function Add(GlobalDocumentKindDto: TGlobalDocumentKindDto): Integer; overload;
      procedure Add(GlobalDocumentKindDtos: TGlobalDocumentKindDtos); overload;
      
      procedure Remove(GlobalDocumentKindDto: TGlobalDocumentKindDto);

      function FindById(const DocumentKindId: Variant): TGlobalDocumentKindDto;
      function FindByIdOrRaise(const DocumentKindId: Variant): TGlobalDocumentKindDto;
      function FindByServiceType(const DocumentKindClass: TDocumentKindClass): TGlobalDocumentKindDto;
      function FindByServiceTypeOrRaise(const DocumentKindClass: TDocumentKindClass): TGlobalDocumentKindDto;

      function FetchNativeDocumentKindDtos: TNativeDocumentKindDtos;

      function GetEnumerator: TDocumentKindDtosEnumerator; override;
      function GetGlobalEnumerator: TGlobalDocumentKindDtosEnumerator;

      property Items[Index: Integer]: TGlobalDocumentKindDto
      read GetGlobalDocumentKindDtoByIndex
      write SetGlobalDocumentKindDtoByIndex; default;

  end;

implementation

uses

  Variants;
  
{ TGlobalDocumentKindDto }

function TGlobalDocumentKindDto.Clone: TDocumentKindDto;
var CloneeGlobalDocumentKindDto: TGlobalDocumentKindDto;
begin

  Result := inherited Clone;

  CloneeGlobalDocumentKindDto := TGlobalDocumentKindDto(Result);

  CloneeGlobalDocumentKindDto.WorkingId := WorkingId;
  CloneeGlobalDocumentKindDto.TopLevelWorkingDocumentKindId := TopLevelWorkingDocumentKindId;
  
end;

constructor TGlobalDocumentKindDto.Create;
begin

  inherited;

  WorkingId := Null;
  TopLevelWorkingDocumentKindId := Null;
  
end;

function TGlobalDocumentKindDto.ToNativeDocumentKindDto: TNativeDocumentKindDto;
begin

  Result := TNativeDocumentKindDto.Create;

  try

    Result.Id := WorkingId;
    Result.TopLevelDocumentKindId := TopLevelWorkingDocumentKindId;
    Result.Name := Name;
    Result.ServiceType := ServiceType;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

{ TGlobalDocumentKindDtosEnumerator }

constructor TGlobalDocumentKindDtosEnumerator.Create(
  GlobalDocumentKindDtos: TGlobalDocumentKindDtos);
begin

  inherited Create(GlobalDocumentKindDtos);

end;

function TGlobalDocumentKindDtosEnumerator.GetCurrentDocumentKindDto: TDocumentKindDto;
begin

  Result := TGlobalDocumentKindDto(inherited GetCurrentDocumentKindDto);
  
end;

function TGlobalDocumentKindDtosEnumerator.GetCurrentGlobalDocumentKindDto: TGlobalDocumentKindDto;
begin

  Result := TGlobalDocumentKindDto(GetCurrentDocumentKindDto);
  
end;

{ TGlobalDocumentKindDtos }

function TGlobalDocumentKindDtos.Add(GlobalDocumentKindDto: TGlobalDocumentKindDto): Integer;
begin

  Result := inherited Add(GlobalDocumentKindDto);
  
end;

procedure TGlobalDocumentKindDtos.Add(
  GlobalDocumentKindDtos: TGlobalDocumentKindDtos);
var
    DocumentKindDto: TDocumentKindDto;
begin

  for DocumentKindDto in GlobalDocumentKindDtos do
    Add(TGlobalDocumentKindDto(DocumentKindDto.Clone));

end;

function TGlobalDocumentKindDtos.FetchNativeDocumentKindDtos: TNativeDocumentKindDtos;
var DocumentKindDto: TDocumentKindDto;
    GlobalEnumerator: TGlobalDocumentKindDtosEnumerator;
begin

  Result := nil;

  try

    for DocumentKindDto in Self do begin

      if DocumentKindDto.ServiceType.InheritsFrom(TNativeDocumentKind)
      then begin

        if not Assigned(Result) then
          Result := TNativeDocumentKindDtos.Create;

        Result.Add(TGlobalDocumentKindDto(DocumentKindDto).ToNativeDocumentKindDto);

      end;

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TGlobalDocumentKindDtos.FindById(
  const DocumentKindId: Variant
): TGlobalDocumentKindDto;

var DocumentKindDto: TDocumentKindDto;
begin

  Result := TGlobalDocumentKindDto(inherited FindById(DocumentKindId));
  
end;

function TGlobalDocumentKindDtos.FindByIdOrRaise(
  const DocumentKindId: Variant): TGlobalDocumentKindDto;
begin

  Result := TGlobalDocumentKindDto(inherited FindByIdOrRaise(DocumentKindId));
  
end;

function TGlobalDocumentKindDtos.FindByServiceType(
  const DocumentKindClass: TDocumentKindClass): TGlobalDocumentKindDto;
begin

  Result := TGlobalDocumentKindDto(inherited FindByServiceType(DocumentKindClass));
  
end;

function TGlobalDocumentKindDtos.FindByServiceTypeOrRaise(
  const DocumentKindClass: TDocumentKindClass): TGlobalDocumentKindDto;
begin

  Result := TGlobalDocumentKindDto(inherited FindByServiceTypeOrRaise(DocumentKindClass));
  
end;

function TGlobalDocumentKindDtos.GetGlobalDocumentKindDtoByIndex(
  Index: Integer): TGlobalDocumentKindDto;
begin

  Result := TGlobalDocumentKindDto(Get(Index));

end;

function TGlobalDocumentKindDtos.GetGlobalEnumerator: TGlobalDocumentKindDtosEnumerator;
begin

  Result := TGlobalDocumentKindDtosEnumerator(GetEnumerator);
  
end;

function TGlobalDocumentKindDtos.GetEnumerator: TDocumentKindDtosEnumerator;
begin

  Result := TGlobalDocumentKindDtosEnumerator.Create(Self);
  
end;

procedure TGlobalDocumentKindDtos.Notify(Ptr: Pointer; Action: TListNotification);
begin

  inherited;

  if (Action = lnDeleted) and Assigned(Ptr) then
    TGlobalDocumentKindDto(Ptr).Destroy;

end;

procedure TGlobalDocumentKindDtos.Remove(GlobalDocumentKindDto: TGlobalDocumentKindDto);
begin

  inherited Remove(GlobalDocumentKindDto);
  
end;

procedure TGlobalDocumentKindDtos.SetGlobalDocumentKindDtoByIndex(Index: Integer;
  const Value: TGlobalDocumentKindDto);
begin

  Put(Index, Value);
  
end;

end.
