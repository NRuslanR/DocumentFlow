unit DocumentSignerViewModelMapper;

interface

uses

  DocumentFlowEmployeeInfoDTO,
  DocumentSignerViewModelUnit,
  SysUtils,
  Classes;

type

  TDocumentSignerViewModelMapper = class

    protected

      function CreateDocumentSignerViewModelInstance:
        TDocumentSignerViewModel; virtual;
        
    public

      function MapDocumentSignerViewModelFrom(
        DocumentFlowEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO
      ): TDocumentSignerViewModel; virtual;
      
  end;

implementation

{ TDocumentSignerViewModelMapper }

function TDocumentSignerViewModelMapper.CreateDocumentSignerViewModelInstance: TDocumentSignerViewModel;
begin

  Result := TDocumentSignerViewModel.Create;
  
end;

function TDocumentSignerViewModelMapper.MapDocumentSignerViewModelFrom(
  DocumentFlowEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO
): TDocumentSignerViewModel;
begin

  Result := CreateDocumentSignerViewModelInstance;

  if Assigned(DocumentFlowEmployeeInfoDTO) then begin

    Result.Id := DocumentFlowEmployeeInfoDTO.Id;
    Result.Name := DocumentFlowEmployeeInfoDTO.FullName;
    Result.Speciality := DocumentFlowEmployeeInfoDTO.Speciality;
    Result.DepartmentCode := DocumentFlowEmployeeInfoDTO.DepartmentInfoDTO.Code;
    Result.DepartmentShortName := DocumentFlowEmployeeInfoDTO.DepartmentInfoDTO.Name;

  end;

end;

end.
