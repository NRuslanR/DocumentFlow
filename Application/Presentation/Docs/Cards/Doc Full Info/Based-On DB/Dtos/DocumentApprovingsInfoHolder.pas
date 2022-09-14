unit DocumentApprovingsInfoHolder;

interface

uses

  DB,
  AbstractDataSetHolder,
  SysUtils;

type

  TDocumentApprovingsInfoFieldNames = class (TAbstractDataSetFieldDefs)

    public

      DocumentApprovingIdFieldName: String;
      DocumentApprovingIsAccessibleFieldName: String;
      DocumentApprovingPerformingDateTimeFieldName: String;
      DocumentApprovingPerformingResultIdFieldName: String;
      DocumentApprovingPerformingResultFieldName: String;
      DocumentApprovingNoteFieldName: String;
      DocumentApprovingIsCompletedFieldName: String;
      DocumentApprovingIsLookedByApproverFieldName: String;

      DocumentApproverIdFieldName: String;
      DocumentApproverLeaderIdFieldName: String;
      DocumentApproverIsForeignFieldName: String;
      DocumentApproverNameFieldName: String;
      DocumentApproverSpecialityFieldName: String;
      DocumentApproverDepartmentIdFieldName: String;
      DocumentApproverDepartmentCodeFieldName: String;
      DocumentApproverDepartmentNameFieldName: String;

      DocumentActualApproverIdFieldName: String;
      DocumentActualApproverLeaderIdFieldName: String;
      DocumentActualApproverIsForeignFieldName: String;
      DocumentActualApproverNameFieldName: String;
      DocumentActualApproverSpecialityFieldName: String;
      DocumentActualApproverDepartmentIdFieldName: String;
      DocumentActualApproverDepartmentCodeFieldName: String;
      DocumentActualApproverDepartmentNameFieldName: String;

      DocumentApprovingCycleNumberFieldName: String;
      DocumentApprovingCycleIdFieldName: String;

  end;

  TDocumentApprovingsInfoHolder = class (TAbstractDataSetHolder)

    private
    
      function GetFieldNames: TDocumentApprovingsInfoFieldNames;
      procedure SetFieldNames(const Value: TDocumentApprovingsInfoFieldNames);

    protected

      function GetDocumentApprovingCycleIdFieldName: Variant;
      function GetDocumentApprovingCycleNumberFieldValue: Variant;
      function GetDocumentActualApproverDepartmentCodeFieldValue: String;
      function GetDocumentActualApproverDepartmentIdFieldValue: Variant;
      function GetDocumentActualApproverDepartmentNameFieldValue: String;
      function GetDocumentActualApproverIdFieldValue: Variant;
      function GetDocumentActualApproverIsForeignFieldValue: Boolean;
      function GetDocumentActualApproverLeaderIdFieldValue: Variant;
      function GetDocumentActualApproverNameFieldValue: String;
      function GetDocumentActualApproverSpecialityFieldValue: String;
      function GetDocumentApproverDepartmentCodeFieldValue: String;
      function GetDocumentApproverDepartmentIdFieldValue: Variant;
      function GetDocumentApproverDepartmentNameFieldValue: String;
      function GetDocumentApproverIdFieldValue: Variant;
      function GetDocumentApproverIsForeignFieldValue: Boolean;
      function GetDocumentApproverLeaderIdFieldValue: Variant;
      function GetDocumentApprovingIsAccessibleFieldValue: Boolean;
      function GetDocumentApproverNameFieldValue: String;
      function GetDocumentApproverSpecialityFieldValue: String;
      function GetDocumentApprovingIdFieldValue: Variant;
      function GetDocumentApprovingIsCompletedFieldValue: Boolean;
      function GetDocumentApprovingNoteFieldValue: String;
      function GetDocumentApprovingPerformingDateTimeFieldValue: Variant;
      function GetDocumentApprovingPerformingResultFieldValue: String;
      function GetDocumentApprovingPerformingResultIdFieldValue: Variant;
      function GetDocumentApprovingIsLookedByApproverFieldValue: Boolean;

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    published

      property FieldNames: TDocumentApprovingsInfoFieldNames
      read GetFieldNames write SetFieldNames;

      property DocumentApprovingIdFieldValue: Variant
      read GetDocumentApprovingIdFieldValue;

      property DocumentApprovingPerformingDateTimeFieldValue: Variant
      read GetDocumentApprovingPerformingDateTimeFieldValue;
      
      property DocumentApprovingPerformingResultIdFieldValue: Variant
      read GetDocumentApprovingPerformingResultIdFieldValue;
      
      property DocumentApprovingPerformingResultFieldValue: String
      read GetDocumentApprovingPerformingResultFieldValue;
      
      property DocumentApprovingNoteFieldValue: String
      read GetDocumentApprovingNoteFieldValue;

      property DocumentApprovingIsCompletedFieldValue: Boolean
      read GetDocumentApprovingIsCompletedFieldValue;

      property DocumentApproverIdFieldValue: Variant
      read GetDocumentApproverIdFieldValue;
      
      property DocumentApproverLeaderIdFieldValue: Variant
      read GetDocumentApproverLeaderIdFieldValue;
      
      property DocumentApproverIsForeignFieldValue: Boolean
      read GetDocumentApproverIsForeignFieldValue;

      property DocumentApproverNameFieldValue: String
      read GetDocumentApproverNameFieldValue;
      
      property DocumentApproverSpecialityFieldValue: String
      read GetDocumentApproverSpecialityFieldValue;

      property DocumentApprovingIsAccessibleFieldValue: Boolean
      read GetDocumentApprovingIsAccessibleFieldValue;
      
      property DocumentApproverDepartmentIdFieldValue: Variant
      read GetDocumentApproverDepartmentIdFieldValue;
      
      property DocumentApproverDepartmentCodeFieldValue: String
      read GetDocumentApproverDepartmentCodeFieldValue;
      
      property DocumentApproverDepartmentNameFieldValue: String
      read GetDocumentApproverDepartmentNameFieldValue;

      property DocumentActualApproverIdFieldValue: Variant
      read GetDocumentActualApproverIdFieldValue;

      property DocumentActualApproverLeaderIdFieldValue: Variant
      read GetDocumentActualApproverLeaderIdFieldValue;
      
      property DocumentActualApproverIsForeignFieldValue: Boolean
      read GetDocumentActualApproverIsForeignFieldValue;
      
      property DocumentActualApproverNameFieldValue: String
      read GetDocumentActualApproverNameFieldValue;
      
      property DocumentActualApproverSpecialityFieldValue: String
      read GetDocumentActualApproverSpecialityFieldValue;
      
      property DocumentActualApproverDepartmentIdFieldValue: Variant
      read GetDocumentActualApproverDepartmentIdFieldValue;
      
      property DocumentActualApproverDepartmentCodeFieldValue: String
      read GetDocumentActualApproverDepartmentCodeFieldValue;
      
      property DocumentActualApproverDepartmentNameFieldValue: String
      read GetDocumentActualApproverDepartmentNameFieldValue;

      property DocumentApprovingIsLookedByApproverFieldValue: Boolean
      read GetDocumentApprovingIsLookedByApproverFieldValue;

      property DocumentApprovingCycleIdFieldValue: Variant
      read GetDocumentApprovingCycleIdFieldName;

      property DocumentApprovingCycleNumberFieldValue: Variant
      read GetDocumentApprovingCycleNumberFieldValue;

  end;

implementation

uses

  Variants;
{ TDocumentApprovingsInfoHolder }


class function TDocumentApprovingsInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentApprovingsInfoFieldNames;
  
  
end;

function TDocumentApprovingsInfoHolder.GetDocumentActualApproverDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentActualApproverDepartmentCodeFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentActualApproverDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentActualApproverDepartmentIdFieldName,
              Null
            );

end;

function TDocumentApprovingsInfoHolder.GetDocumentActualApproverDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentActualApproverDepartmentNameFieldName,
              ''
            );

end;

function TDocumentApprovingsInfoHolder.GetDocumentActualApproverIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentActualApproverIdFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentActualApproverIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentActualApproverIsForeignFieldName,
              False
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentActualApproverLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentActualApproverLeaderIdFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentActualApproverNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentActualApproverNameFieldName,
              ''
            );

end;

function TDocumentApprovingsInfoHolder.GetDocumentActualApproverSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentActualApproverSpecialityFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApproverDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApproverDepartmentCodeFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApproverDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApproverDepartmentIdFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApproverDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApproverDepartmentNameFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApproverIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApproverIdFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApproverIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApproverIsForeignFieldName,
              False
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApproverLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApproverLeaderIdFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApproverNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApproverNameFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApproverSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApproverSpecialityFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApprovingIsAccessibleFieldValue: Boolean;
begin

  Result :=
    GetDataSetFieldValue(
      FieldNames.DocumentApprovingIsAccessibleFieldName,
      False
    );
    
end;

function TDocumentApprovingsInfoHolder.GetDocumentApprovingIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApprovingIdFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApprovingIsCompletedFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApprovingIsCompletedFieldName,
              False
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApprovingIsLookedByApproverFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApprovingIsLookedByApproverFieldName,
              False
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApprovingNoteFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApprovingNoteFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApprovingPerformingDateTimeFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApprovingPerformingDateTimeFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetDocumentApprovingPerformingResultFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApprovingPerformingResultFieldName,
              ''
            );

end;

function TDocumentApprovingsInfoHolder.GetDocumentApprovingPerformingResultIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApprovingPerformingResultIdFieldName,
              Null
            );

end;

function TDocumentApprovingsInfoHolder.GetFieldNames: TDocumentApprovingsInfoFieldNames;
begin

  Result := TDocumentApprovingsInfoFieldNames(inherited FieldDefs);
  
end;

procedure TDocumentApprovingsInfoHolder.SetFieldNames(
  const Value: TDocumentApprovingsInfoFieldNames);
begin

  inherited FieldDefs := Value;
  
end;

function TDocumentApprovingsInfoHolder.GetDocumentApprovingCycleIdFieldName: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApprovingCycleIdFieldName,
              Null
            );

end;

function TDocumentApprovingsInfoHolder.GetDocumentApprovingCycleNumberFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentApprovingCycleNumberFieldName,
              Null
            );
            
end;

end.
