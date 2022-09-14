unit OutcomingDocumentSetHolder;

interface

uses

  AbstractDataSetHolder,
  DocumentSetHolder,
  AbstractDocumentSetHolderDecorator,
  SysUtils,
  Classes;

type

  TOutcomingDocumentSetFieldDefs = class (TAbstractDocumentSetFieldDefsDecorator)

    public

      ReceivingDepartmentNamesFieldName: String;

  end;

  TOutcomingDocumentSetHolder = class (TAbstractDocumentSetHolderDecorator)

    protected
      
      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
    
    protected

      function GetReceivingDepartmentNamesFieldName: String;
      function GetReceivingDepartmentNamesFieldValue: String;

      function GetOutcomingDocumentSetFieldDefs: TOutcomingDocumentSetFieldDefs;

      procedure SetReceivingDepartmentNamesFieldName(const Value: String);
      procedure SetReceivingDepartmentNamesFieldValue(const Value: String);

      procedure SetOutcomingDocumentSetFieldDefs(
        const Value: TOutcomingDocumentSetFieldDefs
      );

    public

      property ReceivingDepartmentNamesFieldName: String
      read GetReceivingDepartmentNamesFieldName
      write SetReceivingDepartmentNamesFieldName;
      
    public

      property ReceivingDepartmentNamesFieldValue: String
      read GetReceivingDepartmentNamesFieldValue
      write SetReceivingDepartmentNamesFieldValue;
      
    public

      property FieldDefs: TOutcomingDocumentSetFieldDefs
      read GetOutcomingDocumentSetFieldDefs
      write SetOutcomingDocumentSetFieldDefs;

  end;
  

implementation

{ TOutcomingDocumentSetHolder }

class function TOutcomingDocumentSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TOutcomingDocumentSetFieldDefs;
  
end;

function TOutcomingDocumentSetHolder.
  GetOutcomingDocumentSetFieldDefs: TOutcomingDocumentSetFieldDefs;
begin

  Result := TOutcomingDocumentSetFieldDefs(inherited FieldDefs);

end;

function TOutcomingDocumentSetHolder.GetReceivingDepartmentNamesFieldName: String;
begin

  Result := FieldDefs.ReceivingDepartmentNamesFieldName;
  
end;

function TOutcomingDocumentSetHolder.GetReceivingDepartmentNamesFieldValue: String;
begin

  Result := GetDataSetFieldValue(ReceivingDepartmentNamesFieldName, '');
  
end;

procedure TOutcomingDocumentSetHolder.SetOutcomingDocumentSetFieldDefs(
  const Value: TOutcomingDocumentSetFieldDefs);
begin

  SetFieldDefs(Value);
  
end;

procedure TOutcomingDocumentSetHolder.SetReceivingDepartmentNamesFieldName(
  const Value: String);
begin

  FieldDefs.ReceivingDepartmentNamesFieldName := Value;
  
end;

procedure TOutcomingDocumentSetHolder.SetReceivingDepartmentNamesFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ReceivingDepartmentNamesFieldName, Value);

end;

end.
