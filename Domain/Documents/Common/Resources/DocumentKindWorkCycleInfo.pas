unit DocumentKindWorkCycleInfo;

interface

uses

  DomainObjectValueUnit,
  DomainObjectValueListUnit,
  Document,
  DocumentWorkCycle,
  SysUtils;

type

  TDocumentKindWorkCycleInfo = class (TDomainObjectValue)

    private

      FDocumentKind: TDocumentClass;
      FDocumentWorkCycle: TDocumentWorkCycle;

    public

      constructor Create(
        DocumentKind: TDocumentClass;
        DocumentWorkCycle: TDocumentWorkCycle
      );

    published

      property DocumentKind: TDocumentClass
      read FDocumentKind write FDocumentKind;

      property DocumentWorkCycle: TDocumentWorkCycle
      read FDocumentWorkCycle write FDocumentWorkCycle;

  end;

  TDocumentKindWorkCycleInfos = class;

  TDocumentKindWorkCycleInfosEnumerator = class (TDomainObjectValueListEnumerator)

    private

      function GetCurrentDocumentKindWorkCycleInfo:
        TDocumentKindWorkCycleInfo;

    public

      constructor Create(
        DocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfos
      );

      property Current: TDocumentKindWorkCycleInfo
      read GetCurrentDocumentKindWorkCycleInfo;

  end;
  
  TDocumentKindWorkCycleInfos = class (TDomainObjectValueList)

    private

      function GetDocumentKindWorkCycleInfoByIndex(
        Index: Integer
      ): TDocumentKindWorkCycleInfo;

      procedure SetDocumentKindWorkCycleInfoByIndex(
        Index: Integer;
        const Value: TDocumentKindWorkCycleInfo
      );

    public

      procedure Add(DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo);

      function Contains(DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo): Boolean;

      procedure Remove(DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo);
      
      function GetEnumerator: TDocumentKindWorkCycleInfosEnumerator;

      property Items[Index: Integer]: TDocumentKindWorkCycleInfo
      read GetDocumentKindWorkCycleInfoByIndex
      write SetDocumentKindWorkCycleInfoByIndex; default;
    
  end;

implementation

{ TDocumentKindWorkCycleInfo }

constructor TDocumentKindWorkCycleInfo.Create(
  DocumentKind: TDocumentClass;
  DocumentWorkCycle: TDocumentWorkCycle
);
begin

  inherited Create;

  FDocumentKind := DocumentKind;
  FDocumentWorkCycle := DocumentWorkCycle;

end;

{ TDocumentKindWorkCycleInfosEnumerator }

constructor TDocumentKindWorkCycleInfosEnumerator.Create(
  DocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfos);
begin

  inherited Create(DocumentKindWorkCycleInfos);
  
end;

function TDocumentKindWorkCycleInfosEnumerator.
  GetCurrentDocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo;
begin

  Result := TDocumentKindWorkCycleInfo(GetCurrentBaseDomainObject);
  
end;

{ TDocumentKindWorkCycleInfos }

procedure TDocumentKindWorkCycleInfos.Add(
  DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo);
begin

  AddDomainObjectValue(DocumentKindWorkCycleInfo);
  
end;

function TDocumentKindWorkCycleInfos.Contains(
  DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo): Boolean;
begin

  Result := inherited Contains(DocumentKindWorkCycleInfo);
  
end;

function TDocumentKindWorkCycleInfos.GetDocumentKindWorkCycleInfoByIndex(
  Index: Integer): TDocumentKindWorkCycleInfo;
begin

  Result := TDocumentKindWorkCycleInfo(GetDomainObjectValueByIndex(Index));

end;

function TDocumentKindWorkCycleInfos.GetEnumerator: TDocumentKindWorkCycleInfosEnumerator;
begin

  Result := TDocumentKindWorkCycleInfosEnumerator.Create(Self);
  
end;

procedure TDocumentKindWorkCycleInfos.Remove(
  DocumentKindWorkCycleInfo: TDocumentKindWorkCycleInfo
);
begin

  DeleteDomainObjectValue(DocumentKindWorkCycleInfo);
  
end;

procedure TDocumentKindWorkCycleInfos.SetDocumentKindWorkCycleInfoByIndex(
  Index: Integer; const Value: TDocumentKindWorkCycleInfo);
begin

  SetDomainObjectValueByIndex(Index, Value);
  
end;

end.
