unit NativeDocumentKindDto;

interface

uses

  SysUtils,
  DocumentKindDto,
  DocumentKinds,
  Classes;

type

  TNativeDocumentKindDto = class (TDocumentKindDto)

  end;

  TNativeDocumentKindDtos = class;

  TNativeDocumentKindDtosEnumerator = class (TDocumentKindDtosEnumerator)

    private

      function GetCurrentNativeDocumentKindDto: TNativeDocumentKindDto;

    protected

      function GetCurrentDocumentKindDto: TDocumentKindDto; override;

    public

      constructor Create(NativeDocumentKindDtos: TNativeDocumentKindDtos);

      property Current: TNativeDocumentKindDto read GetCurrentNativeDocumentKindDto;

  end;

  TNativeDocumentKindDtos = class (TDocumentKindDtos)

    private

      function GetNativeDocumentKindDtoByIndex(Index: Integer): TNativeDocumentKindDto;

      procedure SetNativeDocumentKindDtoByIndex(
        Index: Integer;
        const Value: TNativeDocumentKindDto
      );

    public

      function Add(NativeDocumentKindDto: TNativeDocumentKindDto): Integer;
      procedure Remove(NativeDocumentKindDto: TNativeDocumentKindDto);

      function FindById(const DocumentKindId: Variant): TNativeDocumentKindDto;
      function FindByIdOrRaise(const DocumentKindId: Variant): TNativeDocumentKindDto;
      function FindByServiceType(const DocumentKindClass: TDocumentKindClass): TNativeDocumentKindDto;

      function GetEnumerator: TDocumentKindDtosEnumerator; override;
      function GetNativeEnumerator: TNativeDocumentKindDtosEnumerator;
      
      property Items[Index: Integer]: TNativeDocumentKindDto
      read GetNativeDocumentKindDtoByIndex
      write SetNativeDocumentKindDtoByIndex; default;

  end;

implementation

{ TNativeDocumentKindDtos }

function TNativeDocumentKindDtos.Add(
  NativeDocumentKindDto: TNativeDocumentKindDto): Integer;
begin

  Result := inherited Add(NativeDocumentKindDto);

end;

function TNativeDocumentKindDtos.FindById(
  const DocumentKindId: Variant): TNativeDocumentKindDto;
begin

  Result := TNativeDocumentKindDto(inherited FindById(DocumentKindId));
  
end;

function TNativeDocumentKindDtos.FindByIdOrRaise(
  const DocumentKindId: Variant): TNativeDocumentKindDto;
begin

  Result := TNativeDocumentKindDto(inherited FindByIdOrRaise(DocumentKindId));
  
end;

function TNativeDocumentKindDtos.FindByServiceType(
  const DocumentKindClass: TDocumentKindClass): TNativeDocumentKindDto;
begin

  Result := TNativeDocumentKindDto(inherited FindByServiceType(DocumentKindClass));
  
end;

function TNativeDocumentKindDtos.GetEnumerator: TDocumentKindDtosEnumerator;
begin

  Result := TNativeDocumentKindDtosEnumerator.Create(Self);
  
end;

function TNativeDocumentKindDtos.GetNativeDocumentKindDtoByIndex(
  Index: Integer): TNativeDocumentKindDto;
begin

  Result := TNativeDocumentKindDto(GetDocumentKindDtoByIndex(Index));
  
end;

function TNativeDocumentKindDtos.GetNativeEnumerator: TNativeDocumentKindDtosEnumerator;
begin

  Result := TNativeDocumentKindDtosEnumerator(GetEnumerator);
  
end;

procedure TNativeDocumentKindDtos.Remove(
  NativeDocumentKindDto: TNativeDocumentKindDto);
begin

  inherited Remove(NativeDocumentKindDto);

end;

procedure TNativeDocumentKindDtos.SetNativeDocumentKindDtoByIndex(
  Index: Integer; const Value: TNativeDocumentKindDto);
begin

  SetDocumentKindDtoByIndex(Index, Value);
  
end;

{ TNativeDocumentKindDtosEnumerator }

constructor TNativeDocumentKindDtosEnumerator.Create(
  NativeDocumentKindDtos: TNativeDocumentKindDtos);
begin

  inherited Create(NativeDocumentKindDtos);

end;

function TNativeDocumentKindDtosEnumerator.
  GetCurrentDocumentKindDto: TDocumentKindDto;
begin

  Result := TNativeDocumentKindDto(inherited GetCurrentDocumentKindDto);

end;

function TNativeDocumentKindDtosEnumerator.
  GetCurrentNativeDocumentKindDto: TNativeDocumentKindDto;
begin

  Result := TNativeDocumentKindDto(GetCurrentDocumentKindDto);

end;

end.

