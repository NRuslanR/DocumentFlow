unit DocumentChargeKindDto;

interface

uses


  DocumentFullInfoDTO,
  Classes,
  SysUtils;

type

  TDocumentChargeKindDto = class

    public

      Id: Variant;
      Name: String;
      ServiceName: String;
      ChargeInfoDTOClass: TDocumentChargeInfoDTOClass;

      constructor Create;

  end;

  TDocumentChargeKindDtos = class;
  
  TDocumentChargeKindDtosEnumerator = class (TListEnumerator)

    private

      function GetCurrentDocumentChargeKindDto: TDocumentChargeKindDto;
      
    public

      constructor Create(DocumentChargeKindDtos: TDocumentChargeKindDtos);

      property Current: TDocumentChargeKindDto read GetCurrentDocumentChargeKindDto;

  end;
  
  TDocumentChargeKindDtos = class (TList)

    private

      function GetDocumentChargeKindDtoByIndex(
        Index: Integer
      ): TDocumentChargeKindDto;

      procedure SetDocumentChargeKindDtoByIndex(
        Index: Integer;
        DocumentChargeKindDto: TDocumentChargeKindDto
      );

    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      function GetEnumerator: TDocumentChargeKindDtosEnumerator;

      property Items[Index: Integer]: TDocumentChargeKindDto
      read GetDocumentChargeKindDtoByIndex
      write SetDocumentChargeKindDtoByIndex; default;

  end;

implementation

uses

  Variants;
  
{ TDocumentChargeKindDto }

constructor TDocumentChargeKindDto.Create;
begin

  inherited;

  Id := Null;

end;

{ TDocumentChargeKindDtos }

function TDocumentChargeKindDtos.GetDocumentChargeKindDtoByIndex(
  Index: Integer): TDocumentChargeKindDto;
begin

  Result := TDocumentChargeKindDto(Get(Index));
  
end;

function TDocumentChargeKindDtos.GetEnumerator: TDocumentChargeKindDtosEnumerator;
begin

  Result := TDocumentChargeKindDtosEnumerator.Create(Self);

end;

procedure TDocumentChargeKindDtos.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  if Action = lnDeleted then
    TDocumentChargeKindDto(Ptr).Free;

end;

procedure TDocumentChargeKindDtos.SetDocumentChargeKindDtoByIndex(
  Index: Integer; DocumentChargeKindDto: TDocumentChargeKindDto);
begin

  Put(Index, DocumentChargeKindDto);
  
end;

{ TDocumentChargeKindDtosEnumerator }

constructor TDocumentChargeKindDtosEnumerator.Create(
  DocumentChargeKindDtos: TDocumentChargeKindDtos);
begin

  inherited Create(DocumentChargeKindDtos);
  
end;

function TDocumentChargeKindDtosEnumerator.GetCurrentDocumentChargeKindDto: TDocumentChargeKindDto;
begin

  Result := TDocumentChargeKindDto(inherited GetCurrent);
  
end;

end.
