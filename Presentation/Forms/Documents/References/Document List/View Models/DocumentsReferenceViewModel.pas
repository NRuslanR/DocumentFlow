unit DocumentsReferenceViewModel;

interface

uses

  DocumentTableViewModel,
  DocumentKindWorkCycleColors,
  DocumentKindWorkCycleInfoDto,
  SysUtils,
  Classes;

type

  TDocumentsReferenceViewModel = class

    protected
    
      FDocumentTableViewModel: TDocumentTableViewModel;
      FDocumentKindWorkCycleColors: TDocumentKindWorkCycleColors;
      FDocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;

//      FSelectedDocumentWorkCycleStageInfoDtos: TDocumentKindWorkCycleInfoDtos;
      FSelectedDocumentWorkCycleStageNames: TStrings;

      function GetDocumentTableViewModel:
        TDocumentTableViewModel;

      function GetDocumentKindWorkCycleColors: TDocumentKindWorkCycleColors;

      function GetDocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;

      procedure SetDocumentTableViewModel(
        const Value: TDocumentTableViewModel
      );

      procedure SetDocumentKindWorkCycleColors(
        const Value: TDocumentKindWorkCycleColors
      );

      procedure SetDocumentKindWorkCycleInfoDto(
        const Value: TDocumentKindWorkCycleInfoDto
      );

 {     procedure SetSelectedDocumentWorkCycleStageInfoDtos(
        const Value: TDocumentKindWorkCycleInfoDtos
      );   }

      procedure SetSelectedDocumentWorkCycleStageNames(
        const Value: TStrings
      );

    public

      destructor Destroy; override;

      constructor Create(
        DocumentTableViewModel: TDocumentTableViewModel;
        DocumentKindWorkCycleColors: TDocumentKindWorkCycleColors;
        DocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;
        SelectedDocumentWorkCycleStageNames: TStrings
      ); overload;

    published

      property DocumentTableViewModel: TDocumentTableViewModel
      read GetDocumentTableViewModel
      write SetDocumentTableViewModel;

      property DocumentKindWorkCycleColors: TDocumentKindWorkCycleColors
      read GetDocumentKindWorkCycleColors
      write SetDocumentKindWorkCycleColors;

      property DocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto
      read GetDocumentKindWorkCycleInfoDto write SetDocumentKindWorkCycleInfoDto;

//      property SelectedDocumentWorkCycleStageInfoDtos: TDocumentKindWorkCycleInfoDtos
//      read FSelectedDocumentWorkCycleStageInfoDtos write SetSelectedDocumentWorkCycleStageInfoDtos;

      property SelectedDocumentWorkCycleStageNames: TStrings
      read FSelectedDocumentWorkCycleStageNames write SetSelectedDocumentWorkCycleStageNames;

  end;

  TDocumentsReferenceViewModelClass =
    class of TDocumentsReferenceViewModel;

implementation


{ TDocumentsReferenceViewModel }

constructor TDocumentsReferenceViewModel.Create(
  DocumentTableViewModel: TDocumentTableViewModel;
  DocumentKindWorkCycleColors: TDocumentKindWorkCycleColors;
  DocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;
  SelectedDocumentWorkCycleStageNames: TStrings
);
begin

  inherited Create;

  FDocumentTableViewModel := DocumentTableViewModel;
  FDocumentKindWorkCycleColors := DocumentKindWorkCycleColors;
  FDocumentKindWorkCycleInfoDto := DocumentKindWorkCycleInfoDto;

//  FSelectedDocumentWorkCycleStageInfoDtos := TDocumentKindWorkCycleInfoDtos.Create;
  FSelectedDocumentWorkCycleStageNames := SelectedDocumentWorkCycleStageNames;

end;

destructor TDocumentsReferenceViewModel.Destroy;
begin

  FreeAndNil(FDocumentTableViewModel);
  FreeAndNil(FDocumentKindWorkCycleColors);
  FreeAndNil(FDocumentKindWorkCycleInfoDto);
  FreeAndNil(FSelectedDocumentWorkCycleStageNames);

  inherited;

end;

function TDocumentsReferenceViewModel.GetDocumentKindWorkCycleColors: TDocumentKindWorkCycleColors;
begin

  Result := FDocumentKindWorkCycleColors;
  
end;

function TDocumentsReferenceViewModel.GetDocumentKindWorkCycleInfoDto: TDocumentKindWorkCycleInfoDto;
begin

  Result := FDocumentKindWorkCycleInfoDto;
  
end;

function TDocumentsReferenceViewModel.
  GetDocumentTableViewModel: TDocumentTableViewModel;
begin

  Result := FDocumentTableViewModel;
  
end;

procedure TDocumentsReferenceViewModel.SetDocumentKindWorkCycleColors(
  const Value: TDocumentKindWorkCycleColors);
begin

  FreeAndNil(FDocumentKindWorkCycleColors);
  
  FDocumentKindWorkCycleColors := Value;

end;

procedure TDocumentsReferenceViewModel.SetDocumentKindWorkCycleInfoDto(
  const Value: TDocumentKindWorkCycleInfoDto);
begin

  FDocumentKindWorkCycleInfoDto := Value;
  
end;

procedure TDocumentsReferenceViewModel.SetDocumentTableViewModel(
  const Value: TDocumentTableViewModel);
begin

  FreeAndNil(FDocumentTableViewModel);

  FDocumentTableViewModel := Value;

end;
procedure TDocumentsReferenceViewModel.SetSelectedDocumentWorkCycleStageNames(
  const Value: TStrings);
begin
  FreeAndNil(FSelectedDocumentWorkCycleStageNames);

  FSelectedDocumentWorkCycleStageNames := Value;

end;

{
procedure TDocumentsReferenceViewModel.SetSelectedDocumentWorkCycleStageInfoDtos(
  const Value: TDocumentKindWorkCycleInfoDtos);
begin

  FreeAndNil(FSelectedDocumentWorkCycleStageInfoDtos);
  FSelectedDocumentWorkCycleStageInfoDtos := Value;
end;   }

end.
