unit DocumentApprovingsInfoHolder;

interface

uses

  DB,
  AbstractDataSetHolder,
  SysUtils;

type

  TDocumentApprovingsInfoFieldNames = class (TAbstractDataSetFieldDefs)

    public

      IdFieldName: String;
      IsAccessibleFieldName: String;
      PerformingDateTimeFieldName: String;
      PerformingResultIdFieldName: String;
      PerformingResultFieldName: String;
      PerformingResultServiceNameFieldName: String;
      NoteFieldName: String;
      IsCompletedFieldName: String;
      IsLookedByApproverFieldName: String;

      ApproverIdFieldName: String;
      ApproverLeaderIdFieldName: String;
      ApproverIsForeignFieldName: String;
      ApproverNameFieldName: String;
      ApproverSpecialityFieldName: String;
      ApproverDepartmentIdFieldName: String;
      ApproverDepartmentCodeFieldName: String;
      ApproverDepartmentNameFieldName: String;

      ActualApproverIdFieldName: String;
      ActualApproverLeaderIdFieldName: String;
      ActualApproverIsForeignFieldName: String;
      ActualApproverNameFieldName: String;
      ActualApproverSpecialityFieldName: String;
      ActualApproverDepartmentIdFieldName: String;
      ActualApproverDepartmentCodeFieldName: String;
      ActualApproverDepartmentNameFieldName: String;

      CycleNumberFieldName: String;
      CycleIdFieldName: String;

  end;

  TDocumentApprovingsInfoHolder = class (TAbstractDataSetHolder)

    private
    
      function GetFieldNames: TDocumentApprovingsInfoFieldNames;
      procedure SetFieldNames(const Value: TDocumentApprovingsInfoFieldNames);

    protected

      function GetCycleIdFieldName: Variant;
      function GetCycleNumberFieldValue: Variant;
      function GetActualApproverDepartmentCodeFieldValue: String;
      function GetActualApproverDepartmentIdFieldValue: Variant;
      function GetActualApproverDepartmentNameFieldValue: String;
      function GetActualApproverIdFieldValue: Variant;
      function GetActualApproverIsForeignFieldValue: Boolean;
      function GetActualApproverLeaderIdFieldValue: Variant;
      function GetActualApproverNameFieldValue: String;
      function GetActualApproverSpecialityFieldValue: String;
      function GetApproverDepartmentCodeFieldValue: String;
      function GetApproverDepartmentIdFieldValue: Variant;
      function GetApproverDepartmentNameFieldValue: String;
      function GetApproverIdFieldValue: Variant;
      function GetApproverIsForeignFieldValue: Boolean;
      function GetApproverLeaderIdFieldValue: Variant;
      function GetIsAccessibleFieldValue: Boolean;
      function GetApproverNameFieldValue: String;
      function GetApproverSpecialityFieldValue: String;
      function GetIdFieldValue: Variant;
      function GetIsCompletedFieldValue: Boolean;
      function GetNoteFieldValue: String;
      function GetPerformingDateTimeFieldValue: Variant;
      function GetPerformingResultFieldValue: String;
      function GetPerformingResultIdFieldValue: Variant;
      function GetIsLookedByApproverFieldValue: Boolean;
      function GetPerformingResultServiceNameFieldValue: String;

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    published

      property FieldNames: TDocumentApprovingsInfoFieldNames
      read GetFieldNames write SetFieldNames;

      property IdFieldValue: Variant
      read GetIdFieldValue;

      property PerformingDateTimeFieldValue: Variant
      read GetPerformingDateTimeFieldValue;
      
      property PerformingResultIdFieldValue: Variant
      read GetPerformingResultIdFieldValue;

      property PerformingResultFieldValue: String
      read GetPerformingResultFieldValue;

      property PerformingResultServiceNameFieldValue: String
      read GetPerformingResultServiceNameFieldValue;

      property NoteFieldValue: String
      read GetNoteFieldValue;

      property IsCompletedFieldValue: Boolean
      read GetIsCompletedFieldValue;

      property ApproverIdFieldValue: Variant
      read GetApproverIdFieldValue;
      
      property ApproverLeaderIdFieldValue: Variant
      read GetApproverLeaderIdFieldValue;
      
      property ApproverIsForeignFieldValue: Boolean
      read GetApproverIsForeignFieldValue;

      property ApproverNameFieldValue: String
      read GetApproverNameFieldValue;
      
      property ApproverSpecialityFieldValue: String
      read GetApproverSpecialityFieldValue;

      property IsAccessibleFieldValue: Boolean
      read GetIsAccessibleFieldValue;
      
      property ApproverDepartmentIdFieldValue: Variant
      read GetApproverDepartmentIdFieldValue;
      
      property ApproverDepartmentCodeFieldValue: String
      read GetApproverDepartmentCodeFieldValue;
      
      property ApproverDepartmentNameFieldValue: String
      read GetApproverDepartmentNameFieldValue;

      property ActualApproverIdFieldValue: Variant
      read GetActualApproverIdFieldValue;

      property ActualApproverLeaderIdFieldValue: Variant
      read GetActualApproverLeaderIdFieldValue;
      
      property ActualApproverIsForeignFieldValue: Boolean
      read GetActualApproverIsForeignFieldValue;
      
      property ActualApproverNameFieldValue: String
      read GetActualApproverNameFieldValue;
      
      property ActualApproverSpecialityFieldValue: String
      read GetActualApproverSpecialityFieldValue;
      
      property ActualApproverDepartmentIdFieldValue: Variant
      read GetActualApproverDepartmentIdFieldValue;
      
      property ActualApproverDepartmentCodeFieldValue: String
      read GetActualApproverDepartmentCodeFieldValue;
      
      property ActualApproverDepartmentNameFieldValue: String
      read GetActualApproverDepartmentNameFieldValue;

      property IsLookedByApproverFieldValue: Boolean
      read GetIsLookedByApproverFieldValue;

      property CycleIdFieldValue: Variant
      read GetCycleIdFieldName;

      property CycleNumberFieldValue: Variant
      read GetCycleNumberFieldValue;

  end;

implementation

uses

  Variants;
{ TDocumentApprovingsInfoHolder }


class function TDocumentApprovingsInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentApprovingsInfoFieldNames;
  
  
end;

function TDocumentApprovingsInfoHolder.GetActualApproverDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualApproverDepartmentCodeFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetActualApproverDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualApproverDepartmentIdFieldName,
              Null
            );

end;

function TDocumentApprovingsInfoHolder.GetActualApproverDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualApproverDepartmentNameFieldName,
              ''
            );

end;

function TDocumentApprovingsInfoHolder.GetActualApproverIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualApproverIdFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetActualApproverIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualApproverIsForeignFieldName,
              False
            );
            
end;

function TDocumentApprovingsInfoHolder.GetActualApproverLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualApproverLeaderIdFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetActualApproverNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualApproverNameFieldName,
              ''
            );

end;

function TDocumentApprovingsInfoHolder.GetActualApproverSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualApproverSpecialityFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetApproverDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ApproverDepartmentCodeFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetApproverDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ApproverDepartmentIdFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetApproverDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ApproverDepartmentNameFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetApproverIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ApproverIdFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetApproverIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ApproverIsForeignFieldName,
              False
            );
            
end;

function TDocumentApprovingsInfoHolder.GetApproverLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ApproverLeaderIdFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetApproverNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ApproverNameFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetApproverSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ApproverSpecialityFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetIsAccessibleFieldValue: Boolean;
begin

  Result :=
    GetDataSetFieldValue(
      FieldNames.IsAccessibleFieldName,
      False
    );
    
end;

function TDocumentApprovingsInfoHolder.GetIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IdFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetIsCompletedFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IsCompletedFieldName,
              False
            );
            
end;

function TDocumentApprovingsInfoHolder.GetIsLookedByApproverFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IsLookedByApproverFieldName,
              False
            );
            
end;

function TDocumentApprovingsInfoHolder.GetNoteFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.NoteFieldName,
              ''
            );
            
end;

function TDocumentApprovingsInfoHolder.GetPerformingDateTimeFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.PerformingDateTimeFieldName,
              Null
            );
            
end;

function TDocumentApprovingsInfoHolder.GetPerformingResultFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.PerformingResultFieldName,
              ''
            );

end;

function TDocumentApprovingsInfoHolder.GetPerformingResultIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.PerformingResultIdFieldName,
              Null
            );

end;

function TDocumentApprovingsInfoHolder.GetPerformingResultServiceNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.PerformingResultServiceNameFieldName, '');

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

function TDocumentApprovingsInfoHolder.GetCycleIdFieldName: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.CycleIdFieldName,
              Null
            );

end;

function TDocumentApprovingsInfoHolder.GetCycleNumberFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.CycleNumberFieldName,
              Null
            );
            
end;

end.
