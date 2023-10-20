unit DocumentApprovingsInfoDTOFromDataSetMapper;

interface

uses

  Disposable,
  DocumentFullInfoDTO,
  DepartmentInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  VariantListUnit,
  SysUtils,
  DocumentApprovingsInfoHolder;

type

  TDocumentApprovingsInfoDTOFromDataSetMapper =
    class (TInterfacedObject, IDisposable)

      public

        function CreateDocumentApprovingsInfoDTOInstance: TDocumentApprovingsInfoDTO; virtual;
        function CreateDocumentApprovingInfoDTOInstance: TDocumentApprovingInfoDTO; virtual;

      public

        function MapDocumentApprovingInfoDTOFrom(
          DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
        ): TDocumentApprovingInfoDTO;

        function MapDocumentFormalApproverInfoDTOFrom(
          DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
        ): TDocumentFlowEmployeeInfoDTO;

        function MapDocumentActualApproverInfoDTOFrom(
          DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
        ): TDocumentFlowEmployeeInfoDTO;

      public

        function MapDocumentApprovingsInfoDTOFrom(
          DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
        ): TDocumentApprovingsInfoDTO;
        
    end;

implementation

uses

  Variants;

{ TDocumentApprovingsInfoDTOFromDataSetMapper }

function TDocumentApprovingsInfoDTOFromDataSetMapper
  .MapDocumentApprovingsInfoDTOFrom(
    DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder
  ): TDocumentApprovingsInfoDTO;

var
    DocumentApprovingInfoDTO: TDocumentApprovingInfoDTO;
    HandledDocumentApprovingIds: TVariantList;
begin

  HandledDocumentApprovingIds := TVariantList.Create;

  try

    Result := CreateDocumentApprovingsInfoDTOInstance;
    
    try

      with DocumentApprovingsInfoHolder do begin

        First;

        while not Eof do begin

          if not VarIsNull(IdFieldValue) and
             VarIsNull(CycleNumberFieldValue) and
             not HandledDocumentApprovingIds.Contains(IdFieldValue)

          then begin

            DocumentApprovingInfoDTO :=
              MapDocumentApprovingInfoDTOFrom(DocumentApprovingsInfoHolder);

            Result.Add(DocumentApprovingInfoDTO);

            HandledDocumentApprovingIds.Add(DocumentApprovingInfoDTO.Id);
            
          end;
          
          Next;

        end;

      end;
      
    except

      FreeAndNil(Result);

      raise;

    end;

  finally

    FreeAndNil(HandledDocumentApprovingIds);
    
  end;

end;

function TDocumentApprovingsInfoDTOFromDataSetMapper.MapDocumentApprovingInfoDTOFrom(
  DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder): TDocumentApprovingInfoDTO;
begin

  Result := CreateDocumentApprovingInfoDTOInstance;

  try

    with DocumentApprovingsInfoHolder do begin

      Result.Id := IdFieldValue;
      Result.PerformingDateTime := PerformingDateTimeFieldValue;
      Result.PerformingResultId := PerformingResultIdFieldValue;
      Result.PerformingResultName := PerformingResultFieldValue;
      Result.PerformingResultServiceName := PerformingResultServiceNameFieldValue;
      Result.Note := NoteFieldValue;
      Result.IsViewedByApprover := IsLookedByApproverFieldValue;
      Result.IsAccessible := IsAccessibleFieldValue;

      Result.ApproverInfoDTO :=
        MapDocumentFormalApproverInfoDTOFrom(DocumentApprovingsInfoHolder);

      Result.ActuallyPerformedEmployeeInfoDTO :=
        MapDocumentActualApproverInfoDTOFrom(DocumentApprovingsInfoHolder);

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);

      raise;

    end;

  end;

end;

function TDocumentApprovingsInfoDTOFromDataSetMapper.MapDocumentActualApproverInfoDTOFrom(
  DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder): TDocumentFlowEmployeeInfoDTO;
begin

  Result := TDocumentFlowEmployeeInfoDTO.Create;

  try

    with DocumentApprovingsInfoHolder do begin

      Result.Id := ApproverIdFieldValue;
      Result.LeaderId := ApproverLeaderIdFieldValue;
      Result.IsForeign := ApproverIsForeignFieldValue;
      Result.FullName := ApproverNameFieldValue;
      Result.Speciality := ApproverSpecialityFieldValue;

      Result.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

      Result.DepartmentInfoDTO.Id := ApproverDepartmentIdFieldValue;
      Result.DepartmentInfoDTO.Code := ApproverDepartmentCodeFieldValue;
      Result.DepartmentInfoDTO.Name := ApproverDepartmentNameFieldValue;
  
    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;

end;

function TDocumentApprovingsInfoDTOFromDataSetMapper.MapDocumentFormalApproverInfoDTOFrom(
  DocumentApprovingsInfoHolder: TDocumentApprovingsInfoHolder): TDocumentFlowEmployeeInfoDTO;
begin

  Result := TDocumentFlowEmployeeInfoDTO.Create;

  try

    with DocumentApprovingsInfoHolder do begin

      Result.Id := ApproverIdFieldValue;
      Result.LeaderId := ApproverLeaderIdFieldValue;
      Result.IsForeign := ApproverIsForeignFieldValue;
      Result.FullName := ApproverNameFieldValue;
      Result.Speciality := ApproverSpecialityFieldValue;

      Result.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

      Result.DepartmentInfoDTO.Id := ApproverDepartmentIdFieldValue;
      Result.DepartmentInfoDTO.Code := ApproverDepartmentCodeFieldValue;
      Result.DepartmentInfoDTO.Name := ApproverDepartmentNameFieldValue;
  
    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;
  
end;

function TDocumentApprovingsInfoDTOFromDataSetMapper.CreateDocumentApprovingInfoDTOInstance: TDocumentApprovingInfoDTO;
begin

  Result := TDocumentApprovingInfoDTO.Create;

end;

function TDocumentApprovingsInfoDTOFromDataSetMapper.CreateDocumentApprovingsInfoDTOInstance: TDocumentApprovingsInfoDTO;
begin

  Result := TDocumentApprovingsInfoDTO.Create;
  
end;

end.

