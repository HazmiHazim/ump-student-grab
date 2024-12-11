package com.webapi.ump_student_grab.Mapper;

import com.webapi.ump_student_grab.DTO.LocationDTO.LocationCreateDTO;
import com.webapi.ump_student_grab.DTO.LocationDTO.LocationDTO;
import com.webapi.ump_student_grab.DTO.LocationDTO.LocationUpdateDTO;
import com.webapi.ump_student_grab.Model.Location;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper(componentModel = "spring")
public interface LocationMapper {
    LocationMapper INSTANCE = Mappers.getMapper(LocationMapper.class);

    Location locationCreateDTOToLocation(LocationCreateDTO locationCreateDTO);
    LocationDTO locationToLocationDTO(Location location);
    Location locationUpdateDTOToLocation(LocationUpdateDTO locationUpdateDTO);
}
