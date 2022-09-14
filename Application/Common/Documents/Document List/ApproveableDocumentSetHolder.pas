unit ApproveableDocumentSetHolder;

interface

uses

  AbstractDataSetHolder,
  DocumentSetHolder,
  AbstractDocumentSetHolderDecorator,
  SysUtils;

type

  TApproveableDocumentSetFieldDefs = class (TAbstractDocumentSetFieldDefsDecorator)

    public

      SenderDepartmentNameFieldName: String;
      ReceiverDepartmentNamesFieldName: String;
      
  end;

  TApproveableDocumentSetHolder = class (TAbstractDocumentSetHolderDecorator)

    private
    
    protected

      function GetApproveableDocumentSetFieldDefs: TApproveableDocumentSetFieldDefs;
      function GetReceiverDepartmentNamesFieldName: String;
      function GetReceiverDepartmentNamesFieldValue: String;
      function GetSenderDepartmentNameFieldName: String;
      function GetSenderDepartmentNameFieldValue: String;

      procedure SetApproveableDocumentSetFieldDefs(
        const Value: TApproveableDocumentSetFieldDefs
      );

      procedure SetReceiverDepartmentNamesFieldName(const Value: String);
      procedure SetReceiverDepartmentNamesFieldValue(const Value: String);
      procedure SetSenderDepartmentNameFieldName(const Value: String);
      procedure SetSenderDepartmentNameFieldValue(const Value: String);

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    public

      property SenderDepartmentNameFieldName: String
      read GetSenderDepartmentNameFieldName
      write SetSenderDepartmentNameFieldName;

      property ReceiverDepartmentNamesFieldName: String
      read GetReceiverDepartmentNamesFieldName
      write SetReceiverDepartmentNamesFieldName;

    public

      property SenderDepartmentNameFieldValue: String
      read GetSenderDepartmentNameFieldValue
      write SetSenderDepartmentNameFieldValue;

      property ReceiverDepartmentNamesFieldValue: String
      read GetReceiverDepartmentNamesFieldValue
      write SetReceiverDepartmentNamesFieldValue;

    public

      property FieldDefs: TApproveableDocumentSetFieldDefs
      read GetApproveableDocumentSetFieldDefs
      write SetApproveableDocumentSetFieldDefs;
    
  end;

implementation

{ TApproveableDocumentSetHolder }

function TApproveableDocumentSetHolder.GetApproveableDocumentSetFieldDefs: TApproveableDocumentSetFieldDefs;
begin

  Result := TApproveableDocumentSetFieldDefs(inherited FieldDefs);

end;

class function TApproveableDocumentSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TApproveableDocumentSetFieldDefs;
  
end;

function TApproveableDocumentSetHolder.GetReceiverDepartmentNamesFieldName: String;
begin

  Result := FieldDefs.ReceiverDepartmentNamesFieldName;

end;

function TApproveableDocumentSetHolder.GetReceiverDepartmentNamesFieldValue: String;
begin

  Result := GetDataSetFieldValue(ReceiverDepartmentNamesFieldName, '');
  
end;

function TApproveableDocumentSetHolder.GetSenderDepartmentNameFieldName: String;
begin

  Result := FieldDefs.SenderDepartmentNameFieldName;
  
end;

function TApproveableDocumentSetHolder.GetSenderDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(SenderDepartmentNameFieldName, '');
  
end;

procedure TApproveableDocumentSetHolder.SetApproveableDocumentSetFieldDefs(
  const Value: TApproveableDocumentSetFieldDefs);
begin

  inherited FieldDefs := Value;
  
end;

procedure TApproveableDocumentSetHolder.SetReceiverDepartmentNamesFieldName(
  const Value: String);
begin

  FieldDefs.ReceiverDepartmentNamesFieldName := Value;

end;

procedure TApproveableDocumentSetHolder.SetReceiverDepartmentNamesFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ReceiverDepartmentNamesFieldName, Value);
  
end;

procedure TApproveableDocumentSetHolder.SetSenderDepartmentNameFieldName(
  const Value: String);
begin

  FieldDefs.SenderDepartmentNameFieldName := Value;

end;

procedure TApproveableDocumentSetHolder.SetSenderDepartmentNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(SenderDepartmentNameFieldName, Value);
  
end;

end.
