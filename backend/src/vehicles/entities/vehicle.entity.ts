import { Entity, Column, ManyToOne, OneToMany } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';
import { User } from '../../users/entities/user.entity';
import { Booking } from '../../bookings/entities/booking.entity';

export enum VehicleType {
  SEDAN = 'sedan',
  SUV = 'suv',
  TRUCK = 'truck',
  VAN = 'van',
  COUPE = 'coupe',
  HATCHBACK = 'hatchback',
  MOTORCYCLE = 'motorcycle',
}

@Entity('vehicles')
export class Vehicle extends BaseEntity {
  @Column()
  make: string;

  @Column()
  model: string;

  @Column()
  year: number;

  @Column({ nullable: true })
  color: string;

  @Column({ nullable: true })
  licensePlate: string;

  @Column({ type: 'text', default: VehicleType.SEDAN })
  type: VehicleType;

  @Column({ nullable: true })
  imageUrl: string;

  @ManyToOne(() => User, user => user.vehicles, { onDelete: 'CASCADE' })
  owner: User;

  @Column()
  ownerId: string;

  @OneToMany(() => Booking, booking => booking.vehicle)
  bookings: Booking[];
}
