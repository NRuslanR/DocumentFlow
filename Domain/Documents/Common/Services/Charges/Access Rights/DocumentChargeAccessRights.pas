unit DocumentChargeAccessRights;

interface

uses

  DomainObjectValueUnit,
  DomainObjectValueListUnit,
  SysUtils;

type

  TDocumentChargeAccessRights = class (TDomainObjectValue)

    public

      ChargeSectionAccessible: Boolean;
      RemovingAllowed: Boolean;

      function AllAccessRightsAbsent: Boolean;
      
  end;

  TDocumentChargeAccessRightsList = class;
  
  TDocumentChargeAccessRightsListEnumerator = class (TDomainObjectValueListEnumerator)

    private

      function GetCurrentDocumentChargeAccessRights: TDocumentChargeAccessRights;

    public

      constructor Create(List: TDocumentChargeAccessRightsList);
      
      property Current: TDocumentChargeAccessRights
      read GetCurrentDocumentChargeAccessRights;

  end;

  TDocumentChargeAccessRightsList = class (TDomainObjectValueList)

    private

      function GetDocumentChargeAccessRightsByIndex(
        Index: Integer
      ): TDocumentChargeAccessRights;

      procedure SetDocumentChargeAccessRightsByIndex(
        Index: Integer;
        const Value: TDocumentChargeAccessRights
      );
    
    public

      procedure Add(Value: TDocumentChargeAccessRights);
      
      function GetEnumerator: TDocumentChargeAccessRightsListEnumerator;

      property Items[Index: Integer]: TDocumentChargeAccessRights
      read GetDocumentChargeAccessRightsByIndex
      write SetDocumentChargeAccessRightsByIndex; default;

  end;

implementation

{ TDocumentChargeAccessRightsList }

procedure TDocumentChargeAccessRightsList.Add(
  Value: TDocumentChargeAccessRights);
begin

  AddDomainObjectValue(Value);
  
end;

function TDocumentChargeAccessRightsList.GetDocumentChargeAccessRightsByIndex(
  Index: Integer): TDocumentChargeAccessRights;
begin

  Result := TDocumentChargeAccessRights(GetDomainObjectValueByIndex(Index));

end;

function TDocumentChargeAccessRightsList.GetEnumerator: TDocumentChargeAccessRightsListEnumerator;
begin

  Result := TDocumentChargeAccessRightsListEnumerator.Create(Self);
  
end;

procedure TDocumentChargeAccessRightsList.SetDocumentChargeAccessRightsByIndex(
  Index: Integer; const Value: TDocumentChargeAccessRights);
begin

  SetDomainObjectValueByIndex(Index, Value);

end;

{ TDocumentChargeAccessRightsListEnumerator }

constructor TDocumentChargeAccessRightsListEnumerator.Create(
  List: TDocumentChargeAccessRightsList);
begin

  inherited Create(List);

end;

function TDocumentChargeAccessRightsListEnumerator.GetCurrentDocumentChargeAccessRights: TDocumentChargeAccessRights;
begin

  Result := TDocumentChargeAccessRights(GetCurrentDomainObjectValue);
  
end;

{ TDocumentChargeAccessRights }

function TDocumentChargeAccessRights.AllAccessRightsAbsent: Boolean;
begin

  Result :=
    not (
      ChargeSectionAccessible
      or
      RemovingAllowed
    );
    
end;

end.
